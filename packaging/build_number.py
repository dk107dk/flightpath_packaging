import os


class BuildNumber:

    def __init__(self) -> None:
        self._build_number = None

    @property
    def build_number(self) -> str:
        if self._build_number is None:
            with open("build_number.txt", "r") as file:
                self._build_number = file.read().strip()
        return self._build_number

    @property
    def major(self) -> str:
        build = self.build_number
        return build[0:build.find(".")]

    @property
    def minor(self) -> str:
        build = self.build_number
        return build.split(".")[1]

    @property
    def build(self) -> str:
        build = self.build_number
        return build.split(".")[2]

    """
    def set_build_number_env(self) -> None:
        os.environ["FLIGHTPATH_BUILD"] = self.build_number)
    """

    def increment_build_number(self) -> None:
        major = self.major
        minor = self.minor
        build = int(self.build)
        build += 1
        n = f"{major}.{minor}.{build}"
        with open("build_number.txt", "w") as file:
            file.write(n)
        self._build_number = None

    def increment_minor_number(self) -> None:
        major = self.major
        minor = int(self.minor)
        build = self.build
        minor += 1
        n = f"{major}.{minor}.{build}"
        with open("build_number.txt", "w") as file:
            file.write(n)
        self._build_number = None

    def increment_major_number(self) -> None:
        major = int(self.major)
        minor = self.minor
        build = self.build
        major += 1
        n = f"{major}.{minor}.{build}"
        with open("build_number.txt", "w") as file:
            file.write(n)
        self._build_number = None


if __name__ == "__main__":
    n = BuildNumber()
    n.increment_build_number()

