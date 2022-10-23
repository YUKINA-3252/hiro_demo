(defclass paper-object
  :super cascaded-link
  :slots (paper-x
          paper-y
          paper-z
          paper-x-end
          paper-y-end
          ))

(defmethod paper-object
    (:init
     ()
     (let* (p1 p2 p3 p4 p5 p6 p7 p8 p9 p10-1 p10-2 p11 p12 p13 p14 p15)
       (send-super :init)

       (setq paper-x 250)
       (setq paper-y 700)
       (setq paper-z 5)
       (setq paper-x-end (/ (- paper-x box-x) 2))
       (setq paper-y-end (/ (- (- paper-y (* 2 box-z)) box-y) 2))
       (setq distance-1 (+ (/ box-y 2) (/ box-z 2)))
       (setq distance-2 (+ distance-1 (/ paper-y-end 2)))
       (setq distance-3 (+ (/ box-x 2) (/ paper-x-end 2)))

       (setq p1 (make-cube paper-x-end paper-y-end paper-z))
       (send p1 :locate (send (send (send box-coords :copy-worldcoords) :translate (float-vector (* -1 distance-3) (* -1 distance-2) (* -1 (/ box-z 2))) :world) :worldpos))

       (setq p2 (make-cube box-x paper-y-end paper-z))
       (send p2 :locate (send (send (send box-coords :copy-worldcoords) :translate (float-vector 0 (* -1 distance-2) (* -1 (/ box-z 2))) :world) :worldpos))

       (setq p3 (make-cube paper-x-end paper-y-end paper-z))
       (send p3 :locate (send (send (send box-coords :copy-worldcoords) :translate (float-vector distance-3 (* -1 distance-2) (* -1 (/ box-z 2))) :world) :worldpos))

       (setq p4 (make-cube paper-x-end box-z paper-z))
       (send p4 :locate (send (send (send box-coords :copy-worldcoords) :translate (float-vector (* -1 distance-3) (* -1 distance-1) (* -1 (/ box-z 2))) :world) :worldpos))

       (setq p5 (make-cube box-x box-z paper-z))
       (send p5 :locate (send (send (send box-coords :copy-worldcoords) :translate (float-vector 0 (* -1 distance-1) (* -1 (/ box-z 2))) :world) :worldpos))

       (setq p6 (make-cube paper-x-end box-z paper-z))
       (send p6 :locate (send (send (send box-coords :copy-worldcoords) :translate (float-vector distance-3 (* -1 distance-1) (* -1 (/ box-z 2))) :world) :worldpos))

       (setq p7 (make-cube paper-x-end box-y paper-z))
       (send p7 :locate (send (send (send box-coords :copy-worldcoords) :translate (float-vector (* -1 distance-3) 0 (* -1 (/ box-z 2))) :world) :worldpos))

       (setq p8 (make-cube box-x box-y paper-z))
       (send p8 :locate (send (send (send box-coords :copy-worldcoords) :translate (float-vector 0 0 (* -1 (/ box-z 2))) :world) :worldpos))

       (setq p9 (make-cube paper-x-end box-y paper-z))
       (send p9 :locate (send (send (send box-coords :copy-worldcoords) :translate (float-vector distance-3 0 (* -1 (/ box-z 2))) :world) :worldpos))

       ;; (setq p10 (make-cube paper-x-end box-z paper-z))
       ;; (send p10 :locate (send (send (send box-coords :copy-worldcoords) :translate (float-vector (* -1 distance-3) distance-1 (* -1 (/ box-z 2))) :world) :worldpos))
       (setq p10-1 (make-prism (list (send (send (send box-edge-5 :copy-worldcoords) :translate (float-vector (* -1 paper-x-end) 0 (* -1 (/ paper-z 2))) :world) :worldpos) (send (send (send box-edge-5 :copy-worldcoords) :translate (float-vector (* -1 paper-x-end) box-z (* -1 (/ paper-z 2))) :world) :worldpos) (send (send (send box-edge-5 :copy-worldcoords) :translate (float-vector 0 box-z (* -1 (/ paper-z 2))) :world) :worldpos)) 5))
       (setq p10-2 (make-prism (list (send (send (send box-edge-5 :copy-worldcoords) :translate (float-vector (* -1 paper-x-end) 0 (* -1 (/ paper-z 2))) :world) :worldpos) (send (send (send box-edge-5 :copy-worldcoords) :translate (float-vector 0 0 (* -1 (/ paper-z 2))) :world) :worldpos) (send (send (send box-edge-5 :copy-worldcoords) :translate (float-vector 0 box-z (* -1 (/ paper-z 2))) :world) :worldpos)) 5))

       (setq p11 (make-cube box-x box-z paper-z))
       (send p11 :locate (send (send (send box-coords :copy-worldcoords) :translate (float-vector 0 distance-1 (* -1 (/ box-z 2))) :world) :worldpos))

       (setq p12 (make-cube paper-x-end box-z paper-z))
       (send p12 :locate (send (send (send box-coords :copy-worldcoords) :translate (float-vector distance-3 distance-1 (* -1 (/ box-z 2))) :world) :worldpos))

       (setq p13 (make-cube paper-x-end paper-y-end paper-z))
       (send p13 :locate (send (send (send box-coords :copy-worldcoords) :translate (float-vector (* -1 distance-3) distance-2 (* -1 (/ box-z 2))) :world) :worldpos))

       (setq p14 (make-cube box-x paper-y-end paper-z))
       (send p14 :locate (send (send (send box-coords :copy-worldcoords) :translate (float-vector 0 distance-2 (* -1 (/ box-z 2))) :world) :worldpos))

       (setq p15 (make-cube paper-x-end paper-y-end paper-z))
       (send p15 :locate (send (send (send box-coords :copy-worldcoords) :translate (float-vector distance-3 distance-2 (* -1 (/ box-z 2))) :world) :worldpos))

       (setq paper-lst (list p1 p2 p3 p4 p5 p6 p7 p8 p9 p10-1 p10-2 p11 p12 p13 p14 p15))
       (dotimes (i (length paper-lst))
         (send box-coords :assoc (elt paper-lst i))
         (send (elt paper-lst i) :set-color :goldenrod))

       (setq link1 (instance bodyset-link :init (make-cascoords) :bodies paper-lst))

       ;; (send self :assoc link1)

       (setq links (list link1))
       (send self :init-ending)
       ;; (send box-coords :assoc self)
       (send-all links :worldcoords)
       self)))

(defun paper ()
  (instance paper-object :init)
)
