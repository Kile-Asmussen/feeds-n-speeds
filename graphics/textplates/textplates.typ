#{
  set page(fill: none, height: auto, width: auto, margin: (rest: 0pt))

  let shadow = gradient.linear(
    angle: 30deg,
    black.transparentize(100%),
    black.transparentize(90%),
    black.transparentize(50%),
  )

  let box-it(ct) = box(
    width: 64pt,
    height: 64pt,
    stroke: 1pt + red,
    align(center + horizon, ct) + place(center + horizon, square(size: 64pt, fill: shadow)),
  )

  let fill-image(img) = tiling(image(img, fit: "stretch", width: 64pt, height: 64pt))

  let fill-it = (
    plastic: () => white,
    shadow: () => black,
    iron: () => fill-image("iron-texture.png"),
    copper: () => fill-image("copper-texture.png"),
    uranium: () => fill-image("uranium-texture.png"),
    glass: () => fill-image("glass-texture.png"),
    sulfur: () => fill-image("sulfur-texture.png"),
    wood: () => fill-image("wood-texture.png"),
    brick: () => fill-image("brick-texture.png"),
    concrete: () => fill-image("concrete-texture.png"),
  ).at(sys.inputs.at("fill", default: "plastic"))()


  let letter(scale-it: (:), place-it: (:), c) = {
    place(
      center + horizon,
      ..place-it,
      scale(
        origin: center + horizon,
        ..scale-it,
        text(font: "Bungee", size: 85pt, fill: fill-it)[#c],
      ),
    )
  }

  let zero = box-it(
    letter(scale-it: (y: 90%), "0")
      + place(center + horizon, scale(x: -100%, line(angle: 45deg, stroke: 10pt + fill-it, length: 40pt))),
  )

  let symbol(con) = box-it(scale(y: 95%, con))


  let tooth-displacement = 20pt
  let tooth-size = 10pt
  let tooth(angle) = place(
    dy: calc.cos(angle) * -tooth-displacement,
    dx: calc.sin(angle) * tooth-displacement,
    center + horizon,
    rotate(
      angle,
      square(
        fill: fill-it,
        size: tooth-size,
        radius: 1pt,
      ),
    ),
  )

  let sym-cog = symbol(
    circle(stroke: fill-it + 10pt, radius: 15pt)
      + (0deg, 45deg, 90deg, 135deg, 180deg, 225deg, 270deg, 315deg).map(tooth).sum(),
  )

  let letters(
    scale-it: (:),
    place-it: (:),
    string,
  ) = string.codepoints().map(c => box-it(letter(scale-it: scale-it, place-it: place-it, c)))

  let relative(offset: (0pt, 0pt), ..points) = {
    points = points.pos()
    let curr = points.at(0)
    let res = (curr,)
    for next in points.slice(1) {
      curr = (curr.at(0) + next.at(0), curr.at(1) + next.at(1))
      res.push(curr)
    }
    return res
  }

  let arrow(angle) = symbol(
    rotate(angle, polygon(
      fill: fill-it,
      stroke: stroke(paint: fill-it, thickness: 4pt, join: "round"),
      ..relative(
        (20pt, 0pt),
        (20pt, 20pt),
        (-14.5pt, 0pt),
        (0pt, 30pt),
        (-11pt, 0pt),
        (0pt, -30pt),
        (-14.5pt, 0pt),
      ),
    )),
  )

  let alphabet = "123456789ABCDEFGHIJKLMNOP"
  let letter-q = "Q"
  let alphabet2 = "RSTUVWXYZ"
  let symbols = "!\"#$"
  let pct = "%"
  let symbols2 = "&'()*+,"
  let dash = "-"
  let symbols3 = "./:;<=>?@[\\]^_"
  let accent = "`"
  let symbols4 = "{|}"
  let tilde = "~"

  let extra-symbols = (
    sym.times,
    sym.quote.l.double,
    sym.quote.r.double,
    sym.quote.l.single,
    sym.quote.r.single,
  )
    .map(str)
    .join()

  let sym-circle = symbol(circle(fill: fill-it, radius: 25pt))
  let sym-ring = symbol(circle(stroke: 10pt + fill-it, radius: 20pt))
  let sym-blank = symbol(square(fill: fill-it, size: 35pt, radius: 5pt))
  let sym-square = symbol(square(fill: fill-it, size: 48pt, radius: 5pt))

  grid(
    columns: 36,
    column-gutter: 0pt,
    row-gutter: 0pt,
    zero,
    ..letters(scale-it: (y: 90%), alphabet),
    ..letters(place-it: (dy: -3pt), scale-it: (x: 100%, y: 80%), letter-q),
    ..letters(scale-it: (y: 90%), alphabet2),
    ..letters(scale-it: (x: 80%, y: 70%), symbols),
    ..letters(scale-it: (x: 70%, y: 70%), pct),
    ..letters(scale-it: (x: 80%, y: 70%), symbols2),
    ..letters(scale-it: (x: 150%, y: 70%), dash),
    ..letters(scale-it: (x: 80%, y: 70%), symbols3),
    ..letters(scale-it: (x: 80%, y: 70%), place-it: (dy: 15pt), accent),
    ..letters(scale-it: (x: 80%, y: 70%), symbols4),
    ..letters(scale-it: (x: 80%, y: 100%), tilde),
    [], [], [], [],
    sym-blank, sym-square, sym-circle, sym-ring, sym-cog,
    ..(0deg, 45deg, 90deg, 135deg, 180deg, 225deg, 270deg, 315deg).map(arrow),
    ..letters(scale-it: (x: 80%, y: 70%), extra-symbols),
  )
}


