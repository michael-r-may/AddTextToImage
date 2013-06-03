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

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

#pragma mark - prototypes for functions

NSData* compositedImageRepsWithText(NSArray *imageReps,
                                    CFStringRef imageContentType,
                                    NSString *text);

NSData* convertImageRepDataToImageDataForType(NSData *imageRepData, NSBitmapImageFileType imageFileType) ;

NSBitmapImageFileType fileTypeForFile(NSString *file);

CFStringRef imageContentTypeForFile(NSString *file);

BOOL writeImageDataToFileAsNewImage(NSData* imageRepData, NSString* originalFilename, NSString* destinationFilename);

BOOL addTextToImage(NSString *originalFilename, NSString *compositeText, NSString *destinationFilename);

#pragma mark -

NSData* compositedImageRepsWithText(NSArray *imageReps,
                                    CFStringRef imageContentType,
                                    NSString *text)
{
    NSMutableData *imageData = nil;
    
    BOOL validArguments = (imageReps && imageContentType && text);
    validArguments &= ([(__bridge NSString *)imageContentType length] > 0);
    
    if(validArguments) {
        NSInteger imageSizeWidth = 0;
        NSInteger imageSizeHeight = 0;
        
        [NSGraphicsContext saveGraphicsState];
        
        imageData = [[NSMutableData alloc] init];
        
        CGImageDestinationRef imageDestination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)imageData,
                                                                                  imageContentType,
                                                                                  [imageReps count],
                                                                                  nil);
        
        size_t imageIndex = 0;
        for (NSImageRep * imageRep in imageReps) {
            imageSizeWidth = [imageRep pixelsWide];
            imageSizeHeight = [imageRep pixelsHigh];
            
            CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                               (size_t)imageSizeWidth,
                                                               (size_t)imageSizeHeight,
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
    }
    
    return imageData;
}

NSData* convertImageRepDataToImageDataForType(NSData *imageRepData, NSBitmapImageFileType imageFileType) 
{    
    NSBitmapImageRep *bitmapRep = [NSBitmapImageRep imageRepWithData:imageRepData];
    NSData *imageDataForType = [bitmapRep representationUsingType:imageFileType properties:nil];

    return imageDataForType;
}

#pragma mark -

static NSString *PNGFileExtension = @"png";
static NSString *GIFFileExtension = @"gif";
static NSString *JPGFileExtension = @"jpg";
static NSString *JPEGFileExtension = @"jpeg";

NSBitmapImageFileType fileTypeForFile(NSString *file)
{
    NSString *extension = [[file pathExtension] lowercaseString];
    
    if ([extension isEqualToString:PNGFileExtension])
    {
        return NSPNGFileType;
    }
    else if ([extension isEqualToString:GIFFileExtension])
    {
        return NSGIFFileType;
    }
    else if ([extension isEqualToString:JPGFileExtension] || [extension isEqualToString:JPEGFileExtension])
    {
        return NSJPEGFileType;
    }
    
    return NSTIFFFileType;
}

CFStringRef imageContentTypeForFile(NSString *file)
{
    NSBitmapImageFileType fileType = fileTypeForFile(file);
    
    switch(fileType) {
        case NSPNGFileType:
            return kUTTypePNG;
            break;
            
        case NSGIFFileType:
            return kUTTypeGIF;
            break;
            
        case NSJPEGFileType:
            return kUTTypeJPEG;
            break;
            
        default:
            return kUTTypeImage;
    }
}

#pragma mark - 

BOOL writeImageDataToFileAsNewImage(NSData* imageRepData, NSString* originalFilename, NSString* destinationFilename)
{
    NSBitmapImageFileType imageFileType = fileTypeForFile([originalFilename lastPathComponent]);
    
    NSData *imageDataWithType = convertImageRepDataToImageDataForType(imageRepData, imageFileType);
    
    return [imageDataWithType writeToFile:destinationFilename atomically:YES];
}

#pragma mark - 

BOOL addTextToImage(NSString *originalFilename, NSString *compositeText, NSString *destinationFilename)
{
    BOOL success = NO;
    
    if(originalFilename && compositeText && destinationFilename) {
        NSArray * imageReps = [NSBitmapImageRep imageRepsWithContentsOfFile:originalFilename];
        
        if(imageReps) {
            CFStringRef imageContentType = imageContentTypeForFile(originalFilename);
            NSData *compositedImageData = compositedImageRepsWithText(imageReps, imageContentType, compositeText);
            
            success = writeImageDataToFileAsNewImage(compositedImageData, originalFilename, destinationFilename);
        }
    }
    
    return success;
}


