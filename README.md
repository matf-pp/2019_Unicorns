# CV express :gem:

CV Express program ima za cilj da u programskom jeziku Ruby, na osnovu podataka i želja, vezanim za sam dizajn budućeg CV-a korisnika, kreira odgovarajući CV. 
Program bi u pozadini generisao latex fajl, kao i korisniku nudio razumljiv grafički korisnički interfejs pomoću kog bi unosio neophodne podatke. Korisniku bi se na kraju
isporučivao pdf fajl.

### Članovi tima
- [Bojana Ristanović](https://github.com/BokalinaR) 
- [Lea Petković](https://github.com/leic25)
- [Nikola Stamenić](https://github.com/stuckey10)


#### Instalacija i pokretanja

Da bi se program CV Expres uspešno izvršavao neophodno je posedovati Latex instaliran (sudo apt-get install latex-full).
Naredno što treba odraditi je folder texmf, iz foldera projekta, prekopirati u home direktorijum i zatim pokrenuti komandu
"sudo texhash".
Uz sve to potrebno je imati mogućnost pokretanja Ruby programa uz dodatak FXRuby za grafičko okruženje. 

Da bi se program pokrenuo, posle preuzimanja fajlova, pozicionirati se u direktorijum gde se fajlovi nalaze. 
Narednom "./main.rb" pokrećete program u kom dalje pravite svoj cv.