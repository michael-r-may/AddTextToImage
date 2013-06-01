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

static CGFloat ATTIVersionNumber = 1.0;
static NSInteger ATTIBuildNumber = 4;

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

NSData* compositedImageRepsWithText(NSArray *imageReps,
                                    CFStringRef type,
                                    NSString *text)
{
    NSInteger imageSizeWidth = 0;
    NSInteger imageSizeHeight = 0;
    
    [NSGraphicsContext saveGraphicsState];
    
    NSMutableData *imageData = [[NSMutableData alloc] init];
    CGImageDestinationRef imageDestination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)imageData,
                                                                              type,
                                                                              [imageReps count],
                                                                              nil);
    
    NSInteger imageIndex = 0;
    for (NSImageRep * imageRep in imageReps) {
        imageSizeWidth = [imageRep pixelsWide];
        imageSizeHeight = [imageRep pixelsHigh];
    
        CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                           imageSizeWidth,
                                                           imageSizeHeight,
                                                           8,
                                                           0,
                                                           [[NSColorSpace genericRGBColorSpace] CGColorSpace],
                                                           kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);
            
        [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:bitmapContext flipped:NO]];
        
        [imageRep drawInRect:NSMakeRect(0, 0, imageSizeWidth, imageSizeHeight)
                    fromRect:NSZeroRect
                   operation:NSCompositeCopy
                    fraction:1.0
              respectFlipped:YES
                       hints:nil];
        
        [text drawInRect:NSMakeRect(0, 0, imageSizeWidth, imageSizeHeight)
          withAttributes:nil];
                
        CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
        
        CGContextRelease(bitmapContext);
        
        NSImage *modifiedImage = [[NSImage alloc] initWithCGImage:cgImage size:CGSizeMake(imageSizeWidth, imageSizeHeight)];
        
        NSData *modifiedImageData = [modifiedImage TIFFRepresentation];
        CGImageSourceRef imageSourceDataRef = CGImageSourceCreateWithData((__bridge CFMutableDataRef)modifiedImageData, nil);
        
        CGImageDestinationAddImageFromSource(imageDestination, imageSourceDataRef, imageIndex, nil);
        
        CFRelease(imageSourceDataRef);
        CFRelease(cgImage);
        
        imageIndex++;
    }
    
    CGImageDestinationFinalize(imageDestination);
    CFRelease(imageDestination);
    
    [NSGraphicsContext restoreGraphicsState];    
    
    return imageData;
}

NSBitmapImageFileType fileTypeForFile(NSString *file)
{
    NSString *extension = [[file pathExtension] lowercaseString];
    
    if ([extension isEqualToString:@"png"])
    {
        return NSPNGFileType;
    }
    else if ([extension isEqualToString:@"gif"])
    {
        return NSGIFFileType;
    }
    else if ([extension isEqualToString:@"jpg"] || [extension isEqualToString:@"jpeg"])
    {
        return NSJPEGFileType;
    }

    return NSTIFFFileType;
}

CFStringRef imageContentTypeForFile(NSString *file)
{
    NSString *extension = [[file pathExtension] lowercaseString];
    
    if ([extension isEqualToString:@"png"])
    {
        return kUTTypePNG;
    }
    else if ([extension isEqualToString:@"gif"])
    {
        return kUTTypeGIF;
    }
    else if ([extension isEqualToString:@"jpg"] || [extension isEqualToString:@"jpeg"])
    {
        return kUTTypeJPEG;
    }

    return kUTTypeImage;
}


BOOL writeImageDataToFileAsNewImage(NSData* imageData, NSString* originalFilename, NSString* destinationFilename)
{
    NSBitmapImageFileType fileTypeForFileName = fileTypeForFile([originalFilename lastPathComponent]);
    
    NSBitmapImageRep *bitmapRep = [NSBitmapImageRep imageRepWithData:imageData];
    
    NSData *imageDataWithType = [bitmapRep representationUsingType:fileTypeForFileName properties:nil];
    
    return [imageDataWithType writeToFile:destinationFilename atomically:YES];
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
