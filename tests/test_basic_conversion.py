"""Basic conversion tests for URDF to SDF parser."""
import subprocess
import pytest


class TestBasicConversion:
    """Test cases for basic URDF to SDF conversion."""

    def test_urdf_file_exists(self):
        """Verify sample URDF file is present."""
        from pathlib import Path
        urdf_path = Path("demo/samples/sample.urdf")
        assert urdf_path.exists(), "Sample URDF file should exist"

    def test_sdf_output_contains_model_tag(self):
        """Verify converted SDF contains <model> tag."""
        import subprocess
        from pathlib import Path

        urdf_path = Path("demo/samples/sample.urdf")
        if urdf_path.exists():
            result = subprocess.run(
                ["gz", "service", "-s", "/gazebo/gui/sdf_string",
                 "--reqltype", "gz.msgs.StringMsg",
                 "--reqdata", urdf_path.read_text()],
                capture_output=True, text=True, timeout=30
            )
            assert "<model" in result.stdout, "SDF output should contain <model> tag"

    def test_demo_script_is_executable(self):
        """Verify demo script has executable permissions."""
        from pathlib import Path
        demo_script = Path("demo/run_demo.sh")
        if demo_script.exists():
            assert demo_script.stat().st_mode & 0o111, "Demo script should be executable"
