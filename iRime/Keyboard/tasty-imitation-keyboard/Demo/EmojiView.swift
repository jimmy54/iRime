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
        let keyboardRect = CGRectMake(0, 0, self.frame.size.width, getBannerHeight())
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
    
    
    
    
    func emojiKeyboardView(emojiKeyboardView:AGEmojiKeyboardView, imageForSelectedCategory category:AGEmojiKeyboardViewCategoryImage) -> UIImage {
        
        return UIImage(named: "arrow-up-black")!
    }
    
    
    
    
    
    func emojiKeyboardView(emojiKeyboardView:AGEmojiKeyboardView, imageForNonSelectedCategory category:AGEmojiKeyboardViewCategoryImage) -> UIImage {
        
        return UIImage(named: "arrow-up-black")!
    }
    
    func backSpaceButtonImageForEmojiKeyboardView(emojiKeyboardView:AGEmojiKeyboardView) -> UIImage {
        
        return UIImage(named: "arrow-up-black")!
    }
    
    
    //deleaget
    
    //    - (void)emojiKeyBoardView:(AGEmojiKeyboardView *)emojiKeyBoardView
    //    didUseEmoji:(NSString *)emoji;
    //
    //
    //    - (void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView;
    
    func emojiKeyBoardView(emojiKeyBoardView: AGEmojiKeyboardView!, didUseEmoji emoji: String!) {
        
    }
    
    func emojiKeyBoardViewDidPressBackSpace(emojiKeyBoardView:AGEmojiKeyboardView) {
        
    }

}
