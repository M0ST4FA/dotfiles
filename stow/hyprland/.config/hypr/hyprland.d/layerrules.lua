-- Slurp uses the `selection` layer.  Its fade-out can otherwise be captured
-- by grim immediately after a region is chosen.
hl.layer_rule({
	name = "selection-layer-no-animation",
	match = { namespace = "selection" },
	no_anim = true,
})
