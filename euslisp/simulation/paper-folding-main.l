(load "package://hrpsys_ros_bridge_tutorials/euslisp/hironxjsk-interface.l")
(load "package://hiro_demo/euslisp/paper-model.l")
(load "package://hiro_demo/euslisp/paper-folding-fn.l")
(load "package://roseus_resume/euslisp/interruption-handler.l")
(load "package://hiro_demo/euslisp/hrpsys-collision-check.l")

(hironxjsk-init)

;; define hironxjsk-col
(hrpsys-collision-check-init)

;;use roseus_resume
(roseus_resume:install-interruption-handler *ri*)
(roseus_resume:defintervention
    ik-collision "/ik_collision" std_msgs::String :groupname (*ri* . groupname))
(ros::advertise "/ik_collision" std_msgs::String 10)

;;initial-pose
(defun reset-pose-ir ()
  (send *ri* :angle-vector (send *hironxjsk* :reset-manip-pose) 5000)
  (send *hironxjsk* :larm :move-end-pos #f(0 0 200) :world)
  (send *hironxjsk* :rarm :move-end-pos #f(0 0 200) :world)
  (send *ri* :angle-vector (send *hironxjsk* :angle-vector) 5000)
  (send *hironxjsk* :head :look-at
        (send (send (send *hironxjsk* :torso :end-coords :copy-worldcoords)
                    :translate #f(750 0 0)) :worldpos))
  (setq left-initial-coords (send *hironxjsk* :larm :end-coords :copy-worldcoords))
  (setq right-initial-coords (send *hironxjsk* :rarm :end-coords :copy-worldcoords)))


;;Define box coords
(setq box-coords (instance cascaded-coords :init))
(send box-coords :move-to (make-coords :pos #f(430.664 7.432 25.249) :rpy #f(-1.591 -0.004 3.111)) :world)
(setq box-x 144.184)
(setq box-y 219.735)
(setq box-z 79.9662)

;;Defind 8 corners of box
(setq box-edge-1 (instance cascaded-coords :init))
(send box-edge-1 :move-to (send box-coords :copy-worldcoords) :world)
(send box-edge-1 :translate (float-vector (* -1 (/ box-x 2)) (/ box-y 2) (/ box-z 2)) :world)
(setq box-edge-2 (instance cascaded-coords :init))
(send box-edge-2 :move-to (send box-coords :copy-worldcoords) :world)
(send box-edge-2 :translate (float-vector (* -1 (/ box-x 2)) (* -1 (/ box-y 2)) (/ box-z 2)) :world)
(setq box-edge-3 (instance cascaded-coords :init))
(send box-edge-3 :move-to (send box-coords :copy-worldcoords) :world)
(send box-edge-3 :translate (float-vector (/ box-x 2) (* -1 (/ box-y 2)) (/ box-z 2)) :world)
(setq box-edge-4 (instance cascaded-coords :init))
(send box-edge-4 :move-to (send box-coords :copy-worldcoords) :world)
(send box-edge-4 :translate (float-vector (/ box-x 2) (/ box-y 2) (/ box-z 2)) :world)
(setq box-edge-5 (instance cascaded-coords :init))
(send box-edge-5 :move-to (send box-coords :copy-worldcoords) :world)
(send box-edge-5 :translate (float-vector (* -1 (/ box-x 2)) (/ box-y 2) (* -1 (/ box-z 2))) :world)
(setq box-edge-6 (instance cascaded-coords :init))
(send box-edge-6 :move-to (send box-coords :copy-worldcoords) :world)
(send box-edge-6 :translate (float-vector (* -1 (/ box-x 2)) (* -1 (/ box-y 2)) (* -1 (/ box-z 2))) :world)
(setq box-edge-7 (instance cascaded-coords :init))
(send box-edge-7 :move-to (send box-coords :copy-worldcoords) :world)
(send box-edge-7 :translate (float-vector (/ box-x 2) (* -1 (/ box-y 2)) (* -1 (/ box-z 2))) :world)
(setq box-edge-8 (instance cascaded-coords :init))
(send box-edge-8 :move-to (send box-coords :copy-worldcoords) :world)
(send box-edge-8 :translate (float-vector (/ box-x 2) (* -1 (/ box-y 2)) (* -1 (/ box-z 2))) :world)

(setq box-corner-lst (list box-edge-1 box-edge-2 box-edge-3 box-edge-4 box-edge-5 box-edge-6 box-edge-7 box-edge-8))
(dolist (i box-corner-lst)
  (send box-coords :assoc i))


;;illustrate box
(setq *box* (make-cube box-y box-x box-z))
(send *box* :move-to (send box-coords :copy-worldcoords) :world)))

(setq *paper* (paper))
(send box-coords :assoc *paper*)
(send box-coords :assoc *box*)
(setq ob-list (list *hironxjsk* *box* *paper*))
(objects ob-list)


;; animation
(defun folding-simulation ()
  (reset-pose-ir)
  (unix::sleep 1)
  (wrapping-side)
  (unix::sleep 1)
  (wrapping-up)
  (unix::sleep 1)
  (reach-boxedge)
  (unix::sleep 1)
  (display-listcoords (make-target-coords-list))
  (unix::sleep 1)
  (fold-sim))
