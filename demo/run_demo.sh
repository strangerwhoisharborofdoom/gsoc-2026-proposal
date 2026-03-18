#!/bin/bash
set -e

echo "==========================================="
echo "URDF → SDF Converter Demo"
echo "==========================================="

# Create output directory
mkdir -p /workspace/output

# Run conversion (adjust CLI name to match your implementation)
if [ -f "demo/samples/sample.urdf" ]; then
  echo "Converting demo/samples/sample.urdf → /workspace/output/sample.sdf"
  python3 -c "from urdf_sdf_converter import convert; convert('demo/samples/sample.urdf','/workspace/output/sample.sdf')"
else
  echo "Sample URDF not found at demo/samples/sample.urdf"
  exit 1
fi

# Quick attempt to load in gzserver headless
if command -v gzserver >/dev/null 2>&1; then
  echo "Attempting to spawn model in gzserver headless..."
  gzserver --verbose &
  sleep 3
fi

echo "Demo complete. Output:"
ls -l /workspace/output

echo "==========================================="
echo "Use 'docker run --rm -it gz-demo' to reproduce"
echo "==========================================="

tail -f /dev/null
