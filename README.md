# Installing Imagick on Ubuntu

Go to <https://imagemagick.org/script/download.php> and download the magick binary.

```bash
chmod +x ~/Downloads/magick
sudo mv ~/Downloads/magick /usr/bin
```

# Installeer Imagick op Windows

- Download <https://imagemagick.org/download/binaries/ImageMagick-7.0.9-27-Q16-x64-dll.exe> en voer het installatieprogramma uit. Kies voor alle standaardopties.
- Ga naar <https://git-scm.com/downloads>. Kies voor "Windows". Download het installatieprogramma en voer het uit.
- Open <https://raw.githubusercontent.com/matthiasnoback/magick-cutter/master/run.sh> in de browser. Kies voor "Bestand" > "Pagina opslaan als". Zet het bestand `run.sh` in de map waar je de foto's bewaart.
- Als je alle foto's in de map in een keer wil converteren kan je dubbelklikken op het bestand `run.sh`. Na afloop zie je dan alle plaatjes in de map verschijnen. Lukt het niet, volg dan onderstaande procedure.

- Ga in de verkenner naar de map waar `run.sh` staat.
- Klik rechts op de map en kies voor "Git Bash here".
- Je ziet een zwart venster. Je kunt hier het programma gebruiken.

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
