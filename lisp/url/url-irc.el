;;; url-irc.el --- IRC URL interface

;; Copyright (c) 1996 - 1999 Free Software Foundation, Inc.

;; Keywords: comm, data, processes

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; IRC URLs are defined in http://www.w3.org/Addressing/draft-mirashi-url-irc-01.txt

;;; Code:

(require 'url-vars)
(require 'url-parse)

(defconst url-irc-default-port 6667 "Default port for IRC connections")

(defcustom url-irc-function 'url-irc-zenirc
  "*Function to actually open an IRC connection.
Should be a function that takes several argument:
    HOST - the hostname of the IRC server to contact
    PORT - the port number of the IRC server to contact
 CHANNEL - What channel on the server to visit right away (can be nil)
    USER - What username to use
PASSWORD - What password to use"
  :type '(choice (const :tag "ZEN IRC" :value 'url-irc-zenirc)
		 (function :tag "Other"))
  :group 'url)

(defun url-irc-zenirc (host port channel user password)
  (let ((zenirc-buffer-name (if (and user host port)
				(format "%s@%s:%d" user host port)
			      (format "%s:%d" host port)))
	(zenirc-server-alist
	 (list
	  (list host port password nil user))))
    (zenirc)
    (goto-char (point-max))
    (if (not channel)
	nil
      (insert "/join " channel)
      (zenirc-send-line))))

;;;###autoload
(defun url-irc (url)
  (let* ((host (url-host url))
	 (port (url-port url))
	 (pass (url-password url))
	 (user (url-user url))
	 (chan (url-filename url)))
    (if (url-target url)
	(setq chan (concat chan "#" (url-target url))))
    (if (string-match "^/" chan)
	(setq chan (substring chan 1 nil)))
    (if (= (length chan) 0)
	(setq chan nil))
    (funcall url-irc-function host port chan user pass)
    nil))
    
(provide 'url-irc)

;;; arch-tag: 2e5eecf8-9eb3-436b-9fbd-c26f2fb2bf3e
;;; url-irc.el ends here
