(defun scalar-speed (speed)
  (vec-length speed))

(defun new-scalar-speed (scalar-speed a dt)
  (let ((res (+ scalar-speed (* a dt))))
    (if (< res 0) 0 res)))
(new-scalar-speed 0.5378787878787879 -1 0.25)

(defun stroke (position speed a dt)
  (let ((positions ())
	(scalar-speed (scalar-speed speed))
	(new-scalar-speed)
	(time 0)) 
    (while (> scalar-speed 0)
      ;(push position positions)
      (setq position (vec-add position (vec-scalar-mult speed dt)))
      (setq new-scalar-speed (new-scalar-speed scalar-speed a dt))
      (setq speed (vec-scalar-mult speed (/ new-scalar-speed scalar-speed)))
      (setq scalar-speed new-scalar-speed)
      (incf time dt))
    (list position time)))
;;(stroke '(0.0 0.0) '(3.0 0.0) -1.0 0.001)

(defun stroke-end-position (position speed a dt)
  (vec-add position (vec-scalar-mult (vec-direction speed)
				     (/ (scalar-product speed speed) 2 a))))
;;(stroke-end-position '(0.0 0.0) '(3.0 0.0) -1.0 0.0001)
