
; Couch Potato exercices problem

(define (domain exercices)

  (:requirements 
    :strips
    :typing
    :adl
    :fluents
  )

  (:types
    exercice day - object
  )
  
  (:functions
    (exTime ?ex - exercice)
    (exLevel ?ex - exercice )
    (timeDay)
  )

  (:predicates
    (before ?d1 - day ?d2 - day)
    (precursor ?before - exercice ?after - exercice)
    (preparer ?before - exercice ?after - exercice)
    (currentDay ?day - day)
    (exerciceToday ?exercice - exercice)
    (lastExerciceToday ?exercice - exercice)
  ) 

  (:action do-exercice
    :parameters (?e - exercice )
    :precondition (and
    		(not (exerciceToday ?e)) 
    		(forall (?pr - exercice)
    			(not (and (precursor ?pr ?e) (not (lastExerciceToday ?pr))))
    		)
    		(forall (?p - exercice)
    			(not (and (preparer ?p ?e) (not (exerciceToday ?p))))
    		)
    		(<= (+ (timeDay) (exTime ?e)) 90)
    	)
    :effect (and 
  		(forall (?last - exercice)
  			(when (lastExerciceToday ?last) (not (lastExerciceToday ?last)))
  		)
    		(lastExerciceToday ?e)
    		(exerciceToday ?e)
    		
    		(increase (timeDay) (exTime ?e))
    		
                (increase (exLevel ?e) 1)
    	)
    )

  (:action do-exercice-without-leveling
    :parameters (?e - exercice) 
    :precondition (and
    		(not (exerciceToday ?e)) 
    		(forall (?pr - exercice)
    			(not (and (precursor ?pr ?e) (not (lastExerciceToday ?pr))))
    		)
    		(forall (?p - exercice)
    			(not (and (preparer ?p ?e) (not (exerciceToday ?p))))
    		)
    		(<= (+ (timeDay) (exTime ?e)) 90)
    	)
    :effect (and 
  		(forall (?last - exercice)
  			(when (lastExerciceToday ?last) (not (lastExerciceToday ?last)))
  		)
		(lastExerciceToday ?e)
    		(exerciceToday ?e)
    		
    		(increase (timeDay) (exTime ?e))
    	)
    )

  (:action skip-day
  		:parameters (?d1 ?d2 - day)
  		:precondition (and (currentDay ?d1) (before ?d1 ?d2))
  		:effect (and (not (currentDay ?d1)) (currentDay ?d2)
  				(forall (?e - exercice)
  					(when (exerciceToday ?e) (not (exerciceToday ?e)))
  				)
  				(forall (?e - exercice)
  					(when (lastExerciceToday ?e) (not (lastExerciceToday ?e)))
  				)
  				(assign (timeDay) 0)  				
  			)
  	)

)
