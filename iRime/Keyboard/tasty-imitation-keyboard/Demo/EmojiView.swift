//
//  EmojiView.swift
//  iRime
//
//  Created by jimmy54 on 8/8/16.
//  Copyright © 2016 jimmy54. All rights reserved.
//

import UIKit

class EmojiView: ExtraView, AGEmojiKeyboardViewDataSource, AGEmojiKeyboardViewDelegate {

    var emoji : AGEmojiKeyboardView?
    
    required init(globalColors: GlobalColors.Type?, darkMode: Bool, solidColorMode: Bool) {
        super.init(globalColors: globalColors, darkMode: darkMode, solidColorMode: solidColorMode)
        let keyboardRect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: getBannerHeight())
        emoji = AGEmojiKeyboardView(frame: keyboardRect, dataSource: self)
        //        emojiKeyboardView.autoresizingMask = UIViewAutoresizing.UIViewAutoresizingFlexibleHeight
        emoji!.delegate = self
        self.addSubview(self.emoji!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //    - (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView
    //    imageForSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category;
    //
    //    - (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView
    //    imageForNonSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category;
    //
    //
    //    - (UIImage *)backSpaceButtonImageForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView;
    
    //AGEmoji data datasource
    
    
    
    
    func emojiKeyboardView(_ emojiKeyboardView:AGEmojiKeyboardView, imageForSelectedCategory category:AGEmojiKeyboardViewCategoryImage) -> UIImage {
        
        return UIImage(named: "arrow-up-black")!
    }
    
    
    
    
    
    func emojiKeyboardView(_ emojiKeyboardView:AGEmojiKeyboardView, imageForNonSelectedCategory category:AGEmojiKeyboardViewCategoryImage) -> UIImage {
        
        return UIImage(named: "arrow-up-black")!
    }
    
    func backSpaceButtonImage(for emojiKeyboardView:AGEmojiKeyboardView) -> UIImage {
        
        return UIImage(named: "arrow-up-black")!
    }
    
    
    //deleaget
    
    //    - (void)emojiKeyBoardView:(AGEmojiKeyboardView *)emojiKeyBoardView
    //    didUseEmoji:(NSString *)emoji;
    //
    //
    //    - (void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView;
    
    func emojiKeyBoardView(_ emojiKeyBoardView: AGEmojiKeyboardView!, didUseEmoji emoji: String!) {
        
    }
    
    func emojiKeyBoardViewDidPressBackSpace(_ emojiKeyBoardView:AGEmojiKeyboardView) {
        
    }

}
