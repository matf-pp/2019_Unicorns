# CV express :gem:

>CV Express nastao je kao projekat u okviru kursa Programske paradigme. <br>
Program ima za cilj da na osnovu podataka i želja vezanim za sam dizajn, kreira odgovarajući CV korisniku. 
Program nudi razumljiv grafički korisnički interfejs pomoću kog korisnik unosi neophodne podatke, u pozadini generiše Latex fajl, ali isporučuje PDF fajl.

### Članovi tima :rainbow:
- [Bojana Ristanović](https://github.com/BokalinaR) 🦄
- [Lea Petković](https://github.com/leic25) 🦄
- [Nikola Stamenić](https://github.com/stuckey10) 🦄


#### Instalacija i pokretanje

Da bi se program CV Express uspešno izvršavao neophodno je posedovati Latex instaliran: <br/>
``` sudo apt-get install latex-full ``` <br/>
Naredno što treba odraditi jeste folder texmf, iz foldera projekta, prekopirati u home direktorijum i zatim pokrenuti komandu: <br/>
``` sudo texhash ``` <br/>
Uz sve to potrebno je imati mogućnost pokretanja Ruby programa uz dodatak FXRuby za grafičko okruženje. 

Da bi se program pokrenuo, posle preuzimanja fajlova, pozicionirati se u direktorijum gde se fajlovi nalaze. 
Naredbom  ``` ./main.rb ``` pokrećete program u kom dalje pravite svoj CV.

#### Uputstvo za upotrebu

Nakon pokretanja programa, korisnik ima uvid u album sa slikama CV-eva, tj. kako mogu da izgledaju. Na osnovu slika bira dizajn svog CV-a, i kreće u izradu. Korisniku se nudi odgovarajući GUI,  u odnosu na načinjeni izbor, gde upisuje neophodne i željene informacije. Na kraju svih se nalazi SUBMIT dugme, koje označava početak izrade CV-a, a u nekim postoji i dugme za dodavanje odgovarajuće fotografije.

