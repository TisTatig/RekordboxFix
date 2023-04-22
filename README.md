# WORK IN PROGRESS!

**The idea is that the app will allow you to import your collection's XML file and use that to:**
- Find and merge duplicate tracks
- Find and delete 'garbage tracks' left over from deletion from within RekordBox

# Progress
**Duplicate Merging**
The app finds duplicate tracks and merges their metadata and any additional hot cues the duplicate file has.
Any found duplicates are subsequently moved to a new "DuplicateTracks" folder located in the same directory as the imported XML file from where you can review and delete them manually.

The duplicate finding algorithm still requires some performance enhancements. In its current state it takes a long time to scan large collections.

**Garbage Track Collection**
I've written the pseudocode and that's about it.

# TODO's
- Improve performance of duplicate-finding algorithm through hashing.
- Refactor the app to make it more modular
- Add the garbage collector functionality
- Improve UX/UI