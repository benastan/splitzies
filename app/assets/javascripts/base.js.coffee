@run = (logic) -> _(logic).each (cb, key) -> cb.apply()
