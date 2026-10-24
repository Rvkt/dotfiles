-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
  general = {
    border_size = 2,
    col = {
      active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
  decoration = {
    -- Use round window corners.
    rounding = 8,

    shadow = {
      enabled = true,
      range = 12,
      render_power = 2,
      color = "rgba(00000044)",
    },

    blur = {
      enabled = true,
      size = 5,
      passes = 2,
    },

    -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
    dim_inactive = true,
    dim_strength = 0.25,
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
hl.config({
  animations = {
    enabled = true,
  },
})

-- High-speed minimalist animations
hl.curve("fast", { type = "bezier", points = { { 0.1, 1 }, { 0.1, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "fast", style = "popin 90%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.5, bezier = "fast", style = "popin 90%" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.5, bezier = "fast", style = "slide" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "fast" })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#cursor
hl.config({
  cursor = {
    no_warps = true, -- Don't snap cursor when changing window focus
    inactive_timeout = 5, -- Auto-hide cursor after 5 seconds of inactivity
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })
