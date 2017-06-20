//
//  DefaultKeyboard.swift
//  TransliteratingKeyboard
//
//  Created by Alexei Baboulevitch on 7/10/14.
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.
//

func defaultKeyboard() -> Keyboard {
    let defaultKeyboard = Keyboard()
    
    
    let df = NSString.userDefaultsInGroup()
    
    /**
     *  中文输入法
     */
    
    for key in ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.addKey(keyModel, row: 0, page: 0)
    }
    
    for key in ["A", "S", "D", "F", "G", "H", "J", "K", "L"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.addKey(keyModel, row: 1, page: 0)
    }
    
    var keyModel = Key(.modeChange)
    keyModel.setLetter("符")
    keyModel.toMode = 3
    defaultKeyboard.addKey(keyModel, row: 2, page: 0)
    
    for key in ["Z", "X", "C", "V", "B", "N", "M"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.addKey(keyModel, row: 2, page: 0)
    }
    
    var backspace = Key(.backspace)
    defaultKeyboard.addKey(backspace, row: 2, page: 0)
    
    var keyModeChangeNumbers = Key(.modeChange)
    keyModeChangeNumbers.uppercaseKeyCap = "123"
    keyModeChangeNumbers.toMode = 1
    defaultKeyboard.addKey(keyModeChangeNumbers, row: 3, page: 0)
    
    var keyboardChange = Key(.keyboardChange)
    defaultKeyboard.addKey(keyboardChange, row: 3, page: 0)
    
    var settings = Key(.settings)
    
    var enInput = Key(.modeChange)
    enInput.uppercaseKeyCap = "英"
    enInput.uppercaseOutput = "英"
    enInput.lowercaseKeyCap = "英"
    enInput.toMode = 4
    defaultKeyboard.addKey(enInput, row: 3, page: 0)
    
    
    let chineseInput = Key(.modeChange)
    chineseInput.uppercaseKeyCap = "中"
    chineseInput.uppercaseOutput = "中"
    chineseInput.lowercaseKeyCap = "中"
    chineseInput.toMode = 0
    
    var spaceTitle = "中文键盘";
    if let schemaId = df?.object(forKey: CURRENT_SCHEMA_NAME) {
        spaceTitle = schemaId as! String;
    }
    
    spaceTitle = spaceTitle + "(⇌)"
    
    var space = Key(.space)
    space.uppercaseKeyCap = spaceTitle
    space.lowercaseKeyCap = spaceTitle
    space.uppercaseOutput = " "
    space.lowercaseOutput = " "
    defaultKeyboard.addKey(space, row: 3, page: 0)
    
    var returnKey = Key(.return)
    returnKey.uppercaseKeyCap = "return"
    returnKey.uppercaseOutput = "\n"
    returnKey.lowercaseOutput = "\n"
    defaultKeyboard.addKey(returnKey, row: 3, page: 0)
    
    
    //-------------中文符号------------------------
    
    for key in ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        defaultKeyboard.addKey(keyModel, row: 0, page: 3)
    }
    
    let row = cornerBracketEnabled ? ["-", "/", "：", "；", "（", "）", "$", "@", "「", "」"] : ["-", "/", "：", "；", "（", "）", "$", "@", "“", "”"]
    for key in row {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        
        keyModel.toMode = -1
        
        defaultKeyboard.addKey(keyModel, row: 1, page: 3)
    }
    
    var keyModeChangeSpecialCharacters = Key(.modeChange)
    keyModeChangeSpecialCharacters.uppercaseKeyCap = "#+="
    keyModeChangeSpecialCharacters.toMode = 2
    
    for key in ["。", ",", "+", "_", "、", "？", "！", ".", "，"] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        
        
        keyModel.toMode = -1
        
        defaultKeyboard.addKey(keyModel, row: 2, page: 3)
    }
    
    defaultKeyboard.addKey(Key(backspace), row: 2, page: 3)
    
    
    var back = Key(.modeChange)
    back.setLetter("返回")
    back.toMode = -1
    defaultKeyboard.addKey(back, row: 3, page: 3)
    

    defaultKeyboard.addKey(keyModeChangeSpecialCharacters, row: 3, page: 3)
    
    
    
    space = Key(.space)
    space.uppercaseKeyCap = "中文符号"
    space.lowercaseKeyCap = "中文符号"
    space.uppercaseOutput = " "
    space.lowercaseOutput = " "
    defaultKeyboard.addKey(Key(space), row: 3, page: 3)
    
    defaultKeyboard.addKey(Key(returnKey), row: 3, page: 3)
    
    //--------------------------------------------
    
    
   /**
     *  英文键盘
     */
    
    
    for key in ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.addKey(keyModel, row: 0, page: 4)
    }
    
    for key in ["A", "S", "D", "F", "G", "H", "J", "K", "L"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.addKey(keyModel, row: 1, page: 4)
    }
    
    keyModel = Key(.shift)
    defaultKeyboard.addKey(keyModel, row: 2, page: 4)
    
    for key in ["Z", "X", "C", "V", "B", "N", "M"] {
        let keyModel = Key(.character)
        keyModel.setLetter(key)
        defaultKeyboard.addKey(keyModel, row: 2, page: 4)
    }
    
    backspace = Key(.backspace)
    defaultKeyboard.addKey(backspace, row: 2, page: 4)
    
    
    back = Key(.modeChange)
    back.setLetter("返回")
    back.toMode = -1
    defaultKeyboard.addKey(back, row: 3, page: 4)
    
    keyModeChangeNumbers = Key(.modeChange)
    keyModeChangeNumbers.uppercaseKeyCap = "123"
    keyModeChangeNumbers.toMode = 1
    defaultKeyboard.addKey(keyModeChangeNumbers, row: 3, page: 4)
    
    keyModeChangeSpecialCharacters = Key(.modeChange)
    keyModeChangeSpecialCharacters.uppercaseKeyCap = "#+="
    keyModeChangeSpecialCharacters.toMode = 2
    defaultKeyboard.addKey(keyModeChangeSpecialCharacters, row: 3, page: 4)
    
    let dot = Key(.specialCharacter)
    dot.uppercaseKeyCap = "."
    dot.uppercaseOutput = "."
    dot.lowercaseKeyCap = "."
    dot.setLetter(".")
//    defaultKeyboard.addKey(dot, row: 3, page: 4)
    
//    keyboardChange = Key(.KeyboardChange)
//    defaultKeyboard.addKey(keyboardChange, row: 3, page: 4)
    
//    settings = Key(.Settings)
    space = Key(.space)
    space.uppercaseKeyCap = "英文键盘"
    space.lowercaseKeyCap = "英文键盘"
    space.uppercaseOutput = " "
    space.lowercaseOutput = " "
    defaultKeyboard.addKey(space, row: 3, page: 4)
    
    

    
    returnKey = Key(.return)
    returnKey.uppercaseKeyCap = "return"
    returnKey.uppercaseOutput = "\n"
    returnKey.lowercaseOutput = "\n"
    defaultKeyboard.addKey(returnKey, row: 3, page: 4)
    
    

    //数字键盘
    
    for key in ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        defaultKeyboard.addKey(keyModel, row: 0, page: 1)
    }
    
    for key in ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        
        keyModel.toMode = -1
        
        defaultKeyboard.addKey(keyModel, row: 1, page: 1)
    }
    
    
    for key in [".", ",",  "。", "'", "…", "?", "!", "'", "."] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        
        keyModel.toMode = -1
        
        defaultKeyboard.addKey(keyModel, row: 2, page: 1)
    }
    
    defaultKeyboard.addKey(Key(backspace), row: 2, page: 1)
    
//    keyModeChangeLetters = Key(.ModeChange)
//    keyModeChangeLetters.uppercaseKeyCap = "ABC"
//    keyModeChangeLetters.toMode = 0
//    defaultKeyboard.addKey(keyModeChangeLetters, row: 3, page: 1)
    
//    defaultKeyboard.addKey(Key(chineseInput), row: 3, page: 1)
    back = Key(.modeChange)
    back.setLetter("返回")
    back.toMode = -1
    defaultKeyboard.addKey(back, row: 3, page: 1)
//    defaultKeyboard.addKey(Key(enInput), row: 3, page: 1)
    
    
    keyModeChangeSpecialCharacters = Key(.modeChange)
    keyModeChangeSpecialCharacters.uppercaseKeyCap = "#+="
    keyModeChangeSpecialCharacters.toMode = 2
    defaultKeyboard.addKey(keyModeChangeSpecialCharacters, row: 3, page: 1)
    
    space = Key(.space)
    space.uppercaseKeyCap = "数字键盘"
    space.lowercaseKeyCap = "数字键盘"
    space.uppercaseOutput = " "
    space.lowercaseOutput = " "
    
    
    defaultKeyboard.addKey(Key(space), row: 3, page: 1)
    
    defaultKeyboard.addKey(Key(returnKey), row: 3, page: 1)
    
    
    
    /**
     *  特殊符号
     */
    
    for key in ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        keyModel.toMode = -1
        defaultKeyboard.addKey(keyModel, row: 0, page: 2)
    }
    
    for key in ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        keyModel.toMode = -1
        defaultKeyboard.addKey(keyModel, row: 1, page: 2)
    }
    
//    defaultKeyboard.addKey(Key(keyModeChangeNumbers), row: 2, page: 2)
    
    for key in [".", ",", "?", "!", "'", "……", "《", "》", "~"] {
        let keyModel = Key(.specialCharacter)
        keyModel.setLetter(key)
        keyModel.toMode = -1
        defaultKeyboard.addKey(keyModel, row: 2, page: 2)
    }
    
    defaultKeyboard.addKey(Key(backspace), row: 2, page: 2)
    
//    defaultKeyboard.addKey(Key(keyModeChangeLetters), row: 3, page: 2)
    
//    defaultKeyboard.addKey(Key(chineseInput), row: 3, page: 2)
//    defaultKeyboard.addKey(Key(enInput), row: 3, page: 2)
    
    back = Key(.modeChange)
    back.setLetter("返回")
    back.toMode = -1
    defaultKeyboard.addKey(Key(back), row: 3, page: 2)
    
    
    
    
    space = Key(.space)
    space.uppercaseKeyCap = "英文符号"
    space.lowercaseKeyCap = "英文符号"
    space.uppercaseOutput = " "
    space.lowercaseOutput = " "
    defaultKeyboard.addKey(Key(space), row: 3, page: 2)
    
    defaultKeyboard.addKey(Key(returnKey), row: 3, page: 2)
    
    return defaultKeyboard
}
