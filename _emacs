(global-font-lock-mode t)
(setq default-frame-alist      '((top . 000) (left . 100)
    (width . 80) (height . 32)  
;     (cursor-color . "red")
;    (background-color . "wheat")
;    (vertical-scroll-bars . right)
   ))
   ;fonts found on the mailing list, uncomment one at your convenience
   ;(font . "-*-Courier-normal-r-*-*-13-97-*-*-c-*-*-ansi-")
   ;(font . "-*-Terminal-normal-r-*-*-8-60-*-*-c-*-*-oem-")
   ;(font . "-*-Terminal-normal-r-*-*-12-72-*-*-c-80-*-oem-")
   ;(font . "-*-Terminal-normal-r-*-*-8-60-*-*-c-*-*-oem-")
   ;(font . "
(setq-default font-lock-maximum-decoration t)
(setq line-number-mode t)
(setq line-number-mode t)
;
; octave support
;
(autoload 'octave-mode "octave-mod" nil t)
(autoload 'run-octave "octave-cinf" nil t)
(setq auto-mode-alist
      (cons '("\\.m\\'" . octave-mode) auto-mode-alist))
(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1))))
(add-hook 'inferior-octave-mode-hook
          (lambda ()
            (turn-on-font-lock)
            (define-key inferior-octave-mode-map [up]
              'comint-previous-input)
            (define-key inferior-octave-mode-map [down]
              'comint-next-input)))
(defun RET-behaves-as-LFD ()
  (let ((x (key-binding "\C-j")))
    (local-set-key "\C-m" x)))
(add-hook 'octave-mode-hook 'RET-behaves-as-LFD)

