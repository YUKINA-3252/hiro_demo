(defun get-zforce (topic-name &key (timeout 10))
  (let* (msg
         z-force)

    (while (null msg)
      (setq msg (one-shot-subscribe topic-name
                                    geometry_msgs::WrenchStamped
                                    :timeout (* timeout 1000)))
      )
    (setq z-force (send msg :wrench :force :z))
    z-force))
