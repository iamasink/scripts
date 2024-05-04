#Requires AutoHotkey v2.0

1:: { ; this code will run every time you press 1
    static delay := 50 ; change this to how fast you want to spam (in ms)

    static toggle := false ; initialise toggle variable
    toggle := !toggle ; set toggle to the opposite (ie true if its false, false if true)

    if (toggle) { ; if toggle is true
        SetTimer(spam, delay) ; run the spam function every delay ms, until cancelled
    } else { ; if toggle is false
        SetTimer(spam, 0) ; delete the timer to cancel running the spam function
    }

    spam() { ; declare function
        Send('z')
    }
}