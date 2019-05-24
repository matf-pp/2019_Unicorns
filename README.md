# CV express :gem:

>CV Express nastao je kao projekat u okviru kursa Programske paradigme. <br>
Program ima za cilj da na osnovu podataka i želja vezanim za sam dizajn, kreira odgovarajući CV korisniku. 
Program nudi razumljiv grafički korisnički interfejs pomoću kog korisnik unosi neophodne podatke, u pozadini generiše Latex fajl, ali isporučuje PDF fajl.

Program je napisan u programskom jeziku [Ruby](https://www.ruby-lang.org/en/), na operativnom sistemu Ubuntu. Koristi biblioteku [FXRuby](https://www.sitepoint.com/an-introduction-to-fxruby/), kako bi kreirao odgovarajući GUI.

### Članovi tima :rainbow:
- [Bojana Ristanović](https://github.com/BokalinaR) 🦄
- [Lea Petković](https://github.com/leic25) 🦄
- [Nikola Stamenić](https://github.com/stuckey10) 🦄

<br/>
### Instalacija i pokretanje :computer:

Da bi se program CV Express uspešno izvršavao neophodno je posedovati [Latex](https://www.latex-project.org/) instaliran: <br/>
``` sudo apt-get install latex-full ``` <br/>
Naredno što treba uraditi jeste folder _texmf_, iz foldera projekta, kopirati u _home_ direktorijum i pokrenuti komandu: <br/>
``` sudo texhash ``` <br/>
Uz sve to potrebno je imati mogućnost pokretanja [Ruby](https://www.ruby-lang.org/en/) programa, uz dodatak [FXRuby](https://www.sitepoint.com/an-introduction-to-fxruby/) za grafičko okruženje. 

Da bi se program pokrenuo, nakon preuzimanja fajlova, pozicionirati se u direktorijum gde se fajlovi nalaze.  <br/>
Naredbom  ``` ./main.rb ``` pokrećete program u kom dalje pravite svoj CV.

### Uputstvo za upotrebu :page_with_curl:

Nakon pokretanja programa, korisnik ima uvid u album sa slikama CV-eva, tj. kako mogu da izgledaju. Na osnovu slika bira dizajn svog CV-a i kreće u izradu. Korisniku se nudi odgovarajući GUI,  u odnosu na načinjeni izbor, gde upisuje neophodne i željene informacije. Na kraju svakog grafičkog korisničkog interfejsa nalazi se _submit_ dugme koje označava početak izrade CV-a, a u odredjenim postoji i dugme za dodavanje odgovarajuće fotografije.

