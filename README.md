- Download <https://imagemagick.org/download/binaries/ImageMagick-7.0.9-27-Q16-x64-dll.exe> en voer het installatieprogramma uit.
- Ga naar <https://git-scm.com/downloads>. Kies voor "Windows". Download het installatieprogramma en voer het uit.
- Open <https://raw.githubusercontent.com/matthiasnoback/magick-cutter/master/run.sh> in de browser. Kies voor "Bestand" > "Pagina opslaan als". Zet het bestand `run.sh` in de map waar je de foto's bewaart.
- Ga in de verkenner naar die map.
- Klik rechts op de map en kies voor "Open Git Bash here"
- Je ziet dan een zwart venster. Je kunt dan het programma gebruiken.

Eén plaatje opknippen:

```bash
bash run.sh bronbestand.jpg 4 3 doelbestand
```

Alle plaatjes in deze map opknippen:

```bash
bash run.sh
```

De naam van alle afbeeldingen moet het volgende patroon volgen: `bronbestand_4x3.jpg`
De uitgeknipte plaatjes zijn dan:

```bash
bronbestand_1.jpg
bronbestand_2.jpg
...
```
