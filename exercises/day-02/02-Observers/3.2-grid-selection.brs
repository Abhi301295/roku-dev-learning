' Day 2 / Observers / 3.2 — Grid selection / focus observer
'
' Runs in: a real Roku device, or brs-engine.
'
' Every focusable Roku list publishes selection state through observable
' fields. You don't poll the remote, you don't intercept key events for
' navigation, you don't read internal grid state. You just observe the
' two fields the grid promises to keep up to date:
'
'   itemFocused    integer  index of the item the user is highlighting
'                           (changes as they scroll left/right)
'   itemSelected   integer  index of the item the user pressed OK on
'                           (changes only on an actual selection)
'
' Both are observable on MarkupGrid, RowList, TimeGrid, etc. The platform
' guarantees: itemSelected fires AFTER the focused item has settled, so
' reading `m.movies[idx]` from your AA array is safe.
'
' This file mirrors `onItemSelected` from MainScene.brs verbatim.
'
' Two-array discipline (review from ContentNode set):
'   m.movies        the original AA list (kept on the Scene)
'   m.grid.content  a ContentNode tree built from m.movies
'   onSelected      idx -> m.movies[idx]  (NOT grid.getChild(idx) unless
'                   you carry every needed field on the node too)
'
' Senior gotchas:
'   - itemSelected is "sticky": selecting the same index twice does not
'     re-fire unless the field is alwaysNotify=true. Most channels rely
'     on the user moving focus between selections; if you need
'     double-OK semantics, observe a custom command field instead.
'   - itemFocused fires constantly while scrolling. Don't do expensive
'     work in its callback (no network, no large rebuilds).
'
' BrightScript / SceneGraph                        JavaScript / DOM equivalent
' ----------------------------------------------   ----------------------------------------------
' m.grid.observeField("itemSelected", "onSel")     list.addEventListener("activate", onSel)
' idx = m.grid.itemSelected                        const idx = e.target.selectedIndex
' movie = m.movies[idx]                            const movie = movies[idx]
' playMovie(movie)                                 player.load(movie)
'
' Expected device output (user scrolls then presses OK on index 2):
'   [grid] focus -> 1   (Interstellar)
'   [grid] focus -> 2   (Tenet)
'   [grid] OK    -> 2   (Tenet)
sub init()
    m.grid = m.top.findNode("movieGrid")
    m.movies = []         ' parallel AA array, populated elsewhere

    m.grid.observeField("itemFocused",  "onItemFocused")
    m.grid.observeField("itemSelected", "onItemSelected")
end sub

sub onItemFocused(event as object)
    idx = event.getData()
    if idx < 0 or idx >= m.movies.count() then return
    print "[grid] focus -> " ; idx ; "   (" ; m.movies[idx].title ; ")"
end sub

sub onItemSelected(event as object)
    idx = event.getData()
    if idx < 0 or idx >= m.movies.count() then return
    print "[grid] OK    -> " ; idx ; "   (" ; m.movies[idx].title ; ")"
    playMovie(m.movies[idx])
end sub

sub playMovie(movie as object)
    print "  -> launching player for " ; movie.title
end sub
