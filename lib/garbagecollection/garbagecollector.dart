/* 
1. App creates hashtable based on the paths of all tracks in the collection
2. User selects a folder that contains tracks
3. App goes through the entire folder and its subfolders to find tracks
4. The path of each found track is looked up in the hash table
5. if (!hashtable.contains(trackpath) {lostTrackList.append(trackpath)}
6. move all tracks to LostTracks folder 
 */