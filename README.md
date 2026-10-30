# UmaTextureScripts
Batch ImageMagick 7+ scripts for automatically detailing textures extracted from Umamusume using UmaViewer.

## UmaMobColorizer
Script for coloring the blank white diffusion textures extracted by UmaViewer for mob umas.

### Usage
Run the script and follow the on screen prompts.

The colors for desired mob uma can be found by looking at the game's master database located at `<Umamusume Install Folder><Umamusume Data Folder>\Persistent\master\master.mdb`.

The database can be opened with any SQLite viewer, such as [DB Browser for SQLite](https://sqlitebrowser.org).

#### Example
1. Using DB Browser as an example, go to Browse Data and select the mob_data table.
2. Find the mob_id for the desired mob uma (this will be the same id that appears in UmaViewer), and in the same row locate the id for chara_hair_color. I.e. mob_id 8000 has chara_hair_color 13.
3. Go to the mob_hair_color_set table.
4. Go to the row with the id that matches chara_hair_color. This row contains all of the color values we're looking for.
5.  * For the hair diffusion texture, we want the hair_color values. For id 13, these values are r1:#C39FAC, r2:#ECDC89, g1:#FDB52E, g2:#808080, b1:#494DD4, b2:#FDB52E
    * For the hair shadow texture, we want the hair_toon_color values. For id 13, these values are r1:#CAA3B0, r2:#E59F66, g1:#F87920, g2:#808080, b1:#251980, b2:#F87920
    * For the face diffusion texture, we want the mayu_color (eyebrow color) values. For id 13, these values are r1:#FFFFFF, r2:#FFFFFF, g1:#FFFFFF, g2:#331907, b1:#F87920, b2:#B25717
    * For the face shadow texture, we want the mayu_toon_color values. For id 13, these values are r1:#FFFFFF, r2:#FFFFFF, g1:#FFFFFF, g2:#331907, b1:#F87920, b2:#B25717
    * For the eye texture, we want the eye_color values. For id 13, these values are r1:#4A3521, r2:#D9B167, g1:#FDE3B2, g2:#623C21, b1:#7A572E, b2:#DCB47B
    * For the tail diffusion texture, we want the tail_color values. For id 13, these values are r1:#E6DECF, r2:#FFFFFF, g1:#FFFFFF, g2:#BB9FF8, b1:#FFFFFF, b2:#FDB52E
    * For the tail shadow texture, we want the tail_toon_color values. For id 13, these values are r1:#E6DECF, r2:#FFFFFF, g1:#FFFFFF, g2:#BB9FF8, b1:#FFFFFF, b2:#F87920
6. Input these values when prompted for them by the script.

For shadow textures use the shadow texture when prompted for the diffuse texture.

## UmaTextureDetailer
Script for blending textures together to look similar to their in-game appearance.

Contains three different options:

0. Body/Hair/Tail textures.
1. Face textures.
2. Eye textures.

### Usage
Run the script and follow the on screen prompts.

#### Body/Hair/Tail/Face Textures
The script will blend the diffuse and shadow textures, as well as apply highlights using the base texture.

* Face textures require a slightly different process to remove a layer of white, hence the separate option.

#### Eye Textures
The script will apply the eye highlight textures to the eye diffusion texture.
