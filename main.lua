pad = {}
pad.x = 0
pad.y = 0 
pad.largeur = 20
pad.hauteur = 80
balle = {} 
balle.x = 400 
balle.y = 300
balle.largeur = 20
balle.hauteur = 20 
balle.vitesse_x = 5
balle.vitesse_y = 5
pad2 = {}
pad2.x = love.graphics.getWidth() - 20
pad2.y = 0
pad2.largeur = 20
pad2.hauteur = 80 

scorePad = 0 
scorePad2 = 0 
local start = false

listeTrail = {}

function DebutPartie()
-- Essayer de mettre un premiere ecran avant le lancement du jeu
--  imgFond = love.graphics.newImage("debutPartie.png")
  --    if love.keyboard.isDown("space") then
 --   start = true
 --   CentreBalle()
 --   scorePad2 = 0
 -- end
  
end

function CentreBalle()
  -- Mettre dans une variable la largeur et hauteur MAX de l'ecran 
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  ----------------------
 -- Permet de centrer la balle  
  balle.x = largeur / 2 
  balle.x = balle.x - balle.largeur / 2
  
  balle.y = hauteur / 2
  balle.y = balle.y - balle.hauteur / 2
end

-- Elle permet de ne pas avoir 1-0 en debut de partie (chercher une autre solution 
function scoreGeneral()
    -- Gere le deplacement de la balle en vitesse
  -- Permet de diriger la balle quand le joueur a perdu 
  -- Penser a changer la vitesse
  if balle.x <= 0 then
    balle.vitesse_x = -5
    balle.vitesse_y = -5
    scorePad2 = scorePad2 + 1
    print("score pad 2 : "..tostring(scorePad2))
  else 
    balle.vitesse_x = 5
    balle.vitesse_y = 5
    scorePad = scorePad + 1
    print("score pad 1 : "..scorePad)
  end
end

  function NouvellePartie()
    -- Permet de lancer une nouvelle partie
    if love.keyboard.isDown("space") then
    start = true
    CentreBalle()
    scorePad2 = 0
    scorePad = 0
  end
end

function love.load()
  -- Appel la fonction dès le lancement du jeu
  DebutPartie()
  CentreBalle()
  ----------------------------
  --Gere le son
  fondSon = love.audio.newSource("sons/orage.ogg", "stream")
  murSon = love.audio.newSource("sons/mur.wav", "static")
  perduSon = love.audio.newSource("sons/perdu.wav", "static")
  gagneSon = love.audio.newSource("sons/gagne.mp3", "static")

  local Font = love.graphics.newFont("PixelMaster.ttf", 30)
  love.graphics.setFont(Font)
------------------------
  -- Centre les pads en dabut de partie
  pad2.y = hauteur / 2 - pad2.hauteur / 2
  pad.y = hauteur / 2 - pad.hauteur / 2
end

function love.update(dt)
  
  love.audio.play(fondSon)
  -- Arrete le jeu quand l'un des 2 joueurs arrive a un score précis 
  if scorePad == 3 or scorePad2 == 3 then
    start = false
    love.audio.play(gagneSon)
  end
  -- Fonction qui permet de garder la balle au milieu et mettre le score a 0
  NouvellePartie()
  -- Permet le deplacement de la balle en auto à chaque appel de la fonction Nouvellepartie()
  if start then 
  balle.x = balle.x + balle.vitesse_x 
  balle.y = balle.y + balle.vitesse_y
  end
----------------------------------------
  -- Permet de supprimer les premieres balles inséré
  for n = #listeTrail, 1, -1 do
    local trail = listeTrail[n]
    trail.vie = trail.vie - dt 
    if trail.vie <= 0 then
      table.remove(trail, n)
    end
  end
  -- Tableau pour la trainé (Permet de créer de nouvelle balle
  local trailListe = {}
  trailListe.x = balle.x
  trailListe.y = balle.y
  trailListe.vie = 0.5
  table.insert(listeTrail, trailListe)
  --------------------------------
-- Déplacement joueur 1
  if love.keyboard.isDown("q") and pad.y  <= love.graphics.getHeight() - pad.hauteur then
      pad.y = pad.y + 3
  end

  if pad.y > 0 and love.keyboard.isDown("a") then
      pad.y = pad.y - 3
  end
 ------------------------------------
 -- Deplacemenent joueur 2 
  if love.keyboard.isDown("up") and pad2.y > 0 then
    pad2.y = pad2.y - 3
  end
  
  if love.keyboard.isDown("down") and pad2.y <= love.graphics.getHeight() - pad2.hauteur then
    pad2.y = pad2.y + 3
  end
 -------------------------------------
-- Faire rebondir la balle sur les 4 surfaces (et les pads)  en inversant la direction en multipliant par - 1 
  if balle.x < 0 then
    balle.vitesse_x = balle.vitesse_x * -1
    love.audio.play(perduSon)
  end
  
  if balle.y < 0  then
    balle.vitesse_y = balle.vitesse_y * -1 
    love.audio.play(murSon)
  end
  
  if balle.x > love.graphics.getWidth() - balle.largeur then 
      balle.vitesse_x = balle.vitesse_x * -1
      love.audio.play(perduSon)
  end
  
  if balle.y > love.graphics.getHeight() - balle.hauteur then 
    balle.vitesse_y = -balle.vitesse_y 
    love.audio.play(murSon)
  end
 ------------------------------
-- Faire rebondir la balle sur le pad joueur 1
  if balle.x < pad.x + pad.largeur then
    if balle.y + balle.hauteur > pad.y and balle.y < pad.y + pad.hauteur then
      balle.vitesse_x = -balle.vitesse_x
      balle.x = pad.x + pad.largeur
      love.audio.play(murSon)
    end
  end
  -------
-- Faire rebondir la balle sur le pad joueur 2
  if balle.x + balle.largeur > pad2.x then 
    if balle.y < pad2.y + pad2.hauteur and balle.y + balle.hauteur > pad2.y then
      balle.vitesse_x = -balle.vitesse_x
      balle.x = pad2.x - balle.largeur
      love.audio.play(murSon)
    end
  end
  ---------------------------------
  -- Si perdu recentre la balle et ajuste le score
  if balle.x < 0  or balle.x > love.graphics.getWidth() - balle.largeur then
    scoreGeneral()
    CentreBalle()
  end
end
  
function love.draw()
-- Dessin du pad joueur 1 
  love.graphics.rectangle("fill", pad.x, pad.y, pad.largeur, pad.hauteur) 
-- Dessin du pad Joueur 2 
  love.graphics.rectangle( "fill", pad2.x, pad2.y, pad2.largeur, pad2.hauteur)
--Créer la trainée 
  for n=1, #listeTrail do
    local trail = listeTrail[n]
    local alpha = trail.vie / 2
    love.graphics.setColor(1,1,1,alpha)
    love.graphics.rectangle("fill", trail.x, trail.y, balle.largeur, balle.hauteur)
  end
    love.graphics.setColor(1,1,1,1)  
 -- Dessin de la balle  
  love.graphics.rectangle("fill", balle.x, balle.y, balle.largeur, balle.hauteur)
  
  -- Affiche le score en haut de l'ecran 
  local font = love.graphics.getFont()
  local score = scorePad.."\t"..scorePad2 
  local largeur_score = font:getWidth(score)
  love.graphics.print(score, (love.graphics.getWidth() / 2) - (largeur_score / 2), 5)
  love.graphics.setLineWidth(3)
  love.graphics.line(largeur / 2, 0, largeur / 2, hauteur)
  --------------------------
  -- Déssin d'un fond de premiere page avant de lancer la partie
  --love.graphics.draw(imgFond, 0, 0)
  -- Message d'indication pour le joueur
  if start == false then
   messagePartie = "Appuyez sur \"espace\" pour commencer !" 
  love.graphics.print(messagePartie, largeur / 4, hauteur / 2)
else 
  messagePartie = "Appuyer sur espace pour recommencer..."
  local mess = font:getWidth(messagePartie)
  love.graphics.print(messagePartie, largeur / 2 - mess / 2 , 50)
  end     
  
end
