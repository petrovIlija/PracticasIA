;Práctica 6 - Inteligencia Artificial
;Manuel Sanchez, Pablo Mac-Veigh

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Enumerations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Season
;;
;; Rangos estacionales basados en http://www.almanac.com/content/first-day-seasons
;;
;; 0: primavera (90 dÃ­as 82 - 172)
;; 1: verano    (90 dÃ­as 173 - 263)
;; 2: otoÃ±o     (90 dÃ­as 264 - 354)
;; 3: invierno  (91 dÃ­as 355 - 81)

;; hobby / theme
;;
;; 0: Deportes
;; 1: Aventura
;; 2: Cultura
;; 3: Turismo
;; 4: GastronomÃ­a

;; companion 
;;
;; 0: solo
;; 1: familia
;; 2: amigos

;; languages
;;
;; 0: EspaÃ±ol
;; 1: InglÃ©s
;; 2: FrancÃ©s
;; 3: Chino
;; 4: AlemÃ¡n
;; 5: Indio
;; 6: PortuguÃ©s

(defglobal ?*crlf* = "
")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TEMPLATES DEFINITION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Definition del template del usuario
(deftemplate user
    (slot season(type number)); Ã‰poca del aÃ±o en la que el usuario quiere viajar (ENUMERADO)
    (slot budget(type number)); Presupuesto
    (slot hobby(type number)); AficiÃ³n (ENUMERADO). TODO: multislot varias aficiones
    (slot age(type number)); Edad
    (slot companion(type number)); AcompaÃ±antes (ENUMERADO)
    (slot exotic(type number)); Busca un viaje exÃ³tico? (TRUE:1, FALSE:0)
    (slot languages(type number)); Idioma (ENUMERADO)
)

;DeficiciÃ³n template viaje
(deftemplate travel
	(slot begins(type number)); DÃ­a que empieza el viaje (Ã�ndice 0-364 representando un dÃ­a del aÃ±o)
    (slot ends(type number)); DÃ­a que termina el viaje (Ã�ndice 0-364 representando un dÃ­a del aÃ±o)
    (slot theme(type number)); TemÃ¡tica del viaje (Deporte, turismo, aventura, etc) (ENUMERADO)
    ;TODO ofertas especiales
    (slot language(type number)); Idioma del sitio de destino (Ver languages en user) TODO: multislot varios idiomas
    (slot company(type STRING)); CompaÃ±Ã­a
    (slot name(type STRING)); TÃ­tulo
    (slot description(type STRING)); DescripciÃ³n del viaje     
    ;Añadir continente
    ;Añadir 'dureza' del viaje? (en familia o no)
)

;Definicion del template recomendaciÃ³n
(deftemplate recommendation
    (slot name(type STRING))
    (slot description(type STRING))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FACTS DEFINITIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Asertación de hechos: Usuario de prueba
(deffacts usr
    (user (season 0) (budget 5000) (hobby 2) (age 26) (companion 0) (exotic 1) (languages 3))
    )

;Asertación de hechos: Viajes
(deffacts trvl
    ;(travel (begins) (ends) (theme) (language) (company) (name) (description))
    (travel (begins 20) (ends 30) (theme 2) (language 3) (company "Air China") 
     	(name "Viaje al Tibet") (description "Un viaje al Tibet es todo lo que necesita alguien que busca cultura como tu"))
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SELECTION MODULE ;This module contains all the functions used by the recommendation module
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmodule selection)

(deffunction fitsSeason (?beginDate ?endDate ?userSeason)
    "Devuelve verdadero si la temporada que ha elegido el usuario corresponde con la del viaje"
    ;No s� si las OR y las and pueden ser ternarias o cuaterarias ( con binarias funcionan )
    (return (or 
            	(and (eq ?userSeason 0)(>= ?beginDate 82)(<= ?endDate 172));Primavera del 82 al 172
            	(and (eq ?userSeason 1)(>= ?beginDate 173)(<= ?endDate 263));Verano del 173 al 263
          	    (and (eq ?userSeason 2)(>= ?beginDate 264)(<= ?endDate 354));Oto�o del 264 al 354
            	(and (eq ?userSeason 1)(>= ?beginDate 355)(<= ?endDate 81));Invierno del 355 al 81
            )
        )
    )

(deffunction possibleExoticRule (?travelLanguage ?userExotic ?userLangage)
    (return (and (eq ?userExotic 1) (neq ?travelLangage ?userLangage)))
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RECOMMENDATION MODULE ;This module handles the recomendations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmodule travelRecommendation)

(defrule combine-recommendations 
    "Combiena recomendaciones iguales que puedan salir varias veces"
    ?r1 <- (recommendation (name ?n) (description ?d1))
    ?r2 <- (recommendation (name ?n) (description ?d2&:(neq ?d1 ?d2)))
    =>
    (retract ?r2)
    (modify ?r1 (description (str-cat ?d1 ?*crlf* ?d2))))

(defrule recommend
    "Aserta las recomendaciones si estas se ajustan"
    (travel (name ?tn) (begins ?tb) (ends ?te) (theme ?tt) (language ?tl) (company ?tc) (description ?td)) ;Todos los viajes
    (user (season ?us) (budget ?ub) (hobby ?uh) (age ?ua) (companion ?uc) (exotic ?ue) (languages ?ul)) ;Todos los usuarios
    ;Los hechos sobre Travel empiezan las variables con t y los hechos sobre usuarios empiezan con u.
    
    ;llamadas tipo (test (funcion parametros)))
    (test (fitsSeason ?tb ?te ?us))
    => ;;Si todas las condiciones timpo test se cumplen
    (assert (recommendation (name ?tn) (description ?td))) ;Aserta una recomendaci�n
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; REPORT MODULE; This module handles showing the information on screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmodule report)

(defrule sort-and-print
  ?r1 <- (recommendation (name ?n1) (description ?d1))
  (not (recommendation (name ?n2&:(< (str-compare ?n2 ?n1) 0))))
  =>
  (printout t "You should consider the following trip: " ?n1 crlf)
  (printout t "Description: "  ?d1 crlf crlf)
  (retract ?r1))

(deffunction run-system ()
    "Equivalent to main function"
  (reset);resets all facts
  (focus selection travelRecommendation report) ;order in wich modules will be 'executed'
  (run))

(run-system)
