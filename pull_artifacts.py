import os
import requests

# === CONFIGURATION ===
GITHUB_OWNER = "dk107dk"
GITHUB_REPO = "flightpath_packaging"
GITHUB_BRANCH = "main"
GITHUB_TOKEN = None # os.getenv("GITHUB_TOKEN")  # Set this in your environment

if not os.path.exists("github_token.txt"):
    raise RuntimeError("No github token in github_token.txt")
with open("github_token.txt", "r") as file:
	GITHUB_TOKEN = file.read().strip()

DOWNLOAD_DIR = "artifacts"
HEADERS = {
    "Authorization": f"token {GITHUB_TOKEN}",
    "Accept": "application/vnd.github+json",
    "User-Agent": "FlightPathArtifactDownloader"
}

# === STEP 1: Get latest successful workflow run ===
print("Fetching latest successful workflow run...")
runs_url = f"https://api.github.com/repos/{GITHUB_OWNER}/{GITHUB_REPO}/actions/runs"
params = {"branch": GITHUB_BRANCH, "status": "success", "per_page": 1}
response = requests.get(runs_url, headers=HEADERS, params=params)
response.raise_for_status()
runs = response.json()

if not runs["workflow_runs"]:
    raise RuntimeError("No successful workflow runs found.")

run_id = runs["workflow_runs"][0]["id"]
print(f"Latest run ID: {run_id}")

# === STEP 2: Get artifacts for that run ===
print("Fetching artifacts...")
artifacts_url = f"https://api.github.com/repos/{GITHUB_OWNER}/{GITHUB_REPO}/actions/runs/{run_id}/artifacts"
response = requests.get(artifacts_url, headers=HEADERS)
response.raise_for_status()
artifacts = response.json()

if len(artifacts["artifacts"]) != 3: 
    raise ValueError(f"Should be 3 artifacts, an exe, a signed test msix, and a final unsigned msix. found {len(artifacts["artifacts"])}")

# === STEP 3: Download artifacts ===
os.makedirs(DOWNLOAD_DIR, exist_ok=True)

def download_artifact(artifact_id, filename):
    print(f"Downloading {filename}...")
    url = f"https://api.github.com/repos/{GITHUB_OWNER}/{GITHUB_REPO}/actions/artifacts/{artifact_id}/zip"
    response = requests.get(url, headers=HEADERS, stream=True)
    response.raise_for_status()
    with open(os.path.join(DOWNLOAD_DIR, filename), "wb") as f:
        for chunk in response.iter_content(chunk_size=8192):
            f.write(chunk)

for a in artifacts["artifacts"]:
    download_artifact(a["id"], a["name"])

print("✅ Done!")
