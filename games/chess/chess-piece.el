(require 'chess-square)

(defstruct (chess-piece
	    (:constructor nil)
	    (:constructor make-chess-piece (type side snumber)))
  (type :read-only t)
  (side :read-only t)
  snumber)

(defun parse-chess-move (string)
  (if (= (length string) 2)
    (list 'pawn (snumber string))
    (list (case (upcase (char string 0))
	    (?K 'king) (?Q 'queen) (?R 'rook) (?B 'bishop) (?N 'knight) (?P 'pawn))
	  (snumber (substring string 1)))))
;;(parse-chess-move "pe2")

(defun new-chess-piece (piece-description side)
 (if (symbolp piece-description)
   (new-chess-piece (symbol-name piece-description) side)
   (destructuring-bind (type snumber) (parse-chess-move piece-description)
     (make-chess-piece type side snumber))))
;;(new-chess-piece "Pe2" 'white)

(defun* chess-piece-char (piece &optional (print-pawn-p t))
  (let ((char (case (chess-piece-type piece)
		('king ?K)
		('queen ?Q)
		('rook ?R)
		('bishop ?B)
		('knight ?N)
		('pawn (if print-pawn-p ?P nil)))))
    (and char
	 (if (eq (chess-piece-side piece) 'white) char (downcase char)))))
;;(sstring (chess-piece-char (new-chess-piece 'Pe2 'white) t))

(defun chess-piece-white-p (piece)
  (eq (chess-piece-side piece) 'white))

(defun* chess-piece-print (piece &optional first-move-p (print-pawn-p t))
  (format "%s%s%s"
    (if (and first-move-p 
	     (eq (chess-piece-side piece) 'black))
      ".."  "")
    (upcase (aif (chess-piece-char piece print-pawn-p) (char-to-string it) ""))
    (sname (chess-piece-snumber piece))))
;;(chess-piece-print (new-chess-piece 'b7 'black) nil nil)


(defun copy-pieces (pieces)
  (mapcar #'copy-chess-piece pieces))
;;(copy-pieces white-pieces)

(defun make-pieces (piece-descriptions side)
  (mapcar (bind #'new-chess-piece side) piece-descriptions))

;; (let ((ps (copy-pieces white-pieces)))
;;   (setf (chess-piece-snumber (first ps)) 'qwe))

(defconst white-piece-descriptions '(Ra1 Nb1 Bc1 Qd1 Ke1 Bf1 Ng1 h1 a2 b2 c2 d2 e2 f2 g2 h2))
(defconst black-piece-descriptions '(Ra8 Nb8 Bc8 Qd8 Ke8 Bf8 Ng8 Rh8 a7 b7 c7 d7 e7 f7 g7 h7))
(defconst white-pieces (make-pieces white-piece-descriptions 'white))
(defconst black-pieces (make-pieces black-piece-descriptions 'black))
(defconst all-pieces (append white-pieces black-pieces))

;;simple conversions
(defun piece-to-bposition (piece) (bp-from-snumber (chess-piece-snumber piece)))
(defun pieces-to-snumbers (pieces) (mapcar #'chess-piece-snumber pieces))
(defun pieces-to-bposition (pieces) (bp-from-snumbers (pieces-to-snumbers pieces)))

(defun pieces-to-board-matrix (pieces)
  (let ((bm (make-board-matrix)))
    (loop for p in pieces
	  do (bm-setf bm 
		      (square (chess-piece-snumber p))
		      (chess-piece-char p)))
    bm))
;;(bm-print (pieces-to-board-matrix all-pieces))

(provide 'chess-piece)
