#!/usr/bin/env bash
set -e
git init -b main
git add .
git commit -m "3D conduction calculator: finite-volume steady conduction in the browser"
gh repo create 3d-conduction-calculator --public --source=. --push \
  --description "Steady 3D heat conduction in a rectangular block, in the browser: fixed temperature, heat flux, insulation, convection and radiation on any face; finite-volume solver with 3D surface map and slice viewer"
