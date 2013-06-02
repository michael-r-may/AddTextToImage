// The MIT License (MIT)
//
// Copyright (c) 2013 Michael May
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

/*
 Creation of this utility could not have happened without the awesome Stack Overflow and, in particular, these posts:
 http://stackoverflow.com/questions/3038820/how-to-save-a-nsimage-as-a-new-file
 http://stackoverflow.com/questions/9264051/nsimage-size-not-real-size-with-some-pictures
 
 This useful post on GitHub:
 https://gist.github.com/zachwaugh/1264981
 
 Also, this post about Evan Doll's talk on this subject was the inspiration:
 http://www.merowing.info/2013/03/overlaying-application-version-on-top-of-your-icon/
*/

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

#import "ATTIAddTextToImage.h"

static CGFloat ATTIVersionNumber = 1.0;
static NSInteger ATTIBuildNumber = 5;

#pragma mark -

NSString* stringAtIndexFromArgs(int argc, const char * argv[], int index)
{
    NSString *str = nil;
    
    if(argc >= index) {
        const char *cStringAtIndex = argv[index];
        
        if(cStringAtIndex) {
            str = [NSString stringWithCString:cStringAtIndex encoding:NSUTF8StringEncoding];
        }
    }
    
    return str;
}

NSString* imageSourcePathFromArgs(int argc, const char * argv[])
{
    return stringAtIndexFromArgs(argc, argv, 1);
}

NSString* imageTextFromArgs(int argc, const char * argv[])
{
    return stringAtIndexFromArgs(argc, argv, 2);
}

NSString* imageDestPathFromArgs(int argc, const char * argv[])
{
    return stringAtIndexFromArgs(argc, argv, 3);
}

#pragma mark -

int main(int argc, const char * argv[])
{
    int returnValue = 1;
    
    @autoreleasepool {
        NSString *originalFilename = imageSourcePathFromArgs(argc, argv);
        NSString *compositeText = imageTextFromArgs(argc, argv);
        
        if(originalFilename && compositeText) {
            NSArray * imageReps = [NSBitmapImageRep imageRepsWithContentsOfFile:originalFilename];
            
            if(imageReps) {
                CFStringRef imageContentType = imageContentTypeForFile(originalFilename);
                NSData *compositedImageData = compositedImageRepsWithText(imageReps, imageContentType, compositeText);
                
                NSString *destinationFilename = imageDestPathFromArgs(argc, argv);
                
                returnValue = (writeImageDataToFileAsNewImage(compositedImageData, originalFilename, destinationFilename) == YES) ? 0 : 1;
            }
        } else {
            NSLog(@"%s v%.2f (%ld)", argv[0], ATTIVersionNumber, (long)ATTIBuildNumber);
            NSLog(@"usage: %s <input_filepath> <text> <output_filepath>", argv[0]);
        }
    }
    
    return returnValue;
}
