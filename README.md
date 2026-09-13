# 3D Conduction Calculator

**[Open the calculator in your browser →](https://aiden-azarnoush.github.io/3d-conduction-calculator/)**

Steady heat conduction in a rectangular block, solved by the finite-volume
method in your browser. Set the block size and material, tell it what
happens on each of the six faces — a fixed temperature, a heat source, an
insulated surface, or convection to a fluid (with radiation if you like) —
add internal heat generation if there is any, and press Solve. You get
the block with its surface temperature painted on, a slice viewer to look
inside, the minimum / maximum / average temperature, the heat flow through
every face, and a check that heat in equals heat out.

> [!NOTE]
> This is the companion to the
> [transient conduction estimator](https://github.com/aiden-azarnoush/transient-conduction-estimator).
> That tool answers "is the lumped model allowed, and how fast does the
> block cool?"; this one resolves the temperature *inside* the block when
> the Biot number says gradients matter. It reports the Biot number too, so
> you can see which regime you are in.

## Using it

1. **The block.** Length, width, and height with sliders and boxes, in mm,
   cm, m, in, or ft. The sketch stays proportional (clamped at 10:1 so a
   thin plate still draws as a plate) and colors each visible face by its
   boundary condition.
2. **Material.** Eleven common metals, plastics, and glass, or type your own
   conductivity (W/m·K or BTU/hr·ft·°F).
3. **Grid.** Coarse, medium, or fine. The tool sizes the grid from the block
   proportions (the longest side gets 16, 28, or 40 cells; never fewer than
   4; at most about 70,000 cells) so the page stays responsive.
4. **Faces.** For each of the six faces choose fixed temperature, heat flux
   in (W/m², total watts, or BTU/hr·ft²), insulated, or convection with an
   h and a fluid temperature, plus optional radiation (emissivity and
   surroundings temperature). Temperatures in °C, °F, or K. Internal heat
   generation in watts or W/m³.
5. **Results.** Rotate the 3D block, slide a plane through it along x, y,
   or z, and read the numbers.

> [!TIP]
> Start with the default: an aluminum bar heated from below and cooled by
> air on the other faces. Then change the bottom face to a fixed 200 °C, or
> insulate the sides, and watch the surface map and the face heat flows
> respond.

> [!IMPORTANT]
> A steady state needs at least one face that lets heat out (a fixed
> temperature or convection). If every face is a heat source or insulated,
> the tool says so instead of returning nonsense.

## How it works

The block is divided into cells. Each cell exchanges heat with its
neighbors through the conductance $k A / d$, and each boundary cell
exchanges heat with its face according to the boundary condition:

| Condition | Heat leaving the cell through the face |
|---|---|
| fixed temperature $T_b$ | $\dfrac{kA}{d/2}\,(T_{cell} - T_b)$ |
| heat flux $q$ in | $-\,qA$ |
| insulated | $0$ |
| convection | $\dfrac{T_{cell} - T_\infty}{\dfrac{1}{hA} + \dfrac{d/2}{kA}}$ — the half-cell conduction in series with the film |
| radiation (with convection) | $h \to h + \varepsilon\sigma\,(T_s + T_{sur})(T_s^2 + T_{sur}^2)$, updated by fixed-point iteration |

Writing "heat in = heat out" for every cell gives a sparse symmetric
linear system, solved with a Jacobi-preconditioned conjugate-gradient
method. Because the convection term uses the half-cell conduction in
series, the face temperature is recovered exactly from the adjacent cell,
and that is what the 3D view paints.

### Verification

The discretization was checked against exact answers before the page was
built: a 1D slab with fixed temperatures on two faces reproduces the
linear profile to 10⁻⁸; a flux-in / convection-out slab reproduces
$T_{face} = T_\infty + q/h$ and the drop $qL/k$; a block with internal
generation and convection on all faces balances energy and matches the
lumped estimate; and a radiating face converges to
$\varepsilon\sigma(T^4 - T_{sur}^4)$. The same tests were run on a
line-for-line transliteration of the JavaScript solver.

## Roadmap

- Transient mode with a time slider (initial temperature, duration, snapshots).
- Convection coefficients from correlations: forced (fluid, velocity,
  flat-plate Nusselt) and natural (fluid, orientation, Rayleigh number).

## License

MIT — see [LICENSE](LICENSE).
