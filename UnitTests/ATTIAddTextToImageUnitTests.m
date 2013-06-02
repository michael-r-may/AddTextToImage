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

#import <Foundation/Foundation.h>

#import "ATTIAddTextToImageUnitTests.h"

#import "ATTIAddTextToImage.h"

@implementation ATTIAddTextToImageUnitTests

NSString *GIFFilePath = @"/my/dir/test.gif";
NSString *JPGFilePath = @"/my/dir/test.jpg";
NSString *JPEGFilePath = @"/my/dir/test.jpeg";
NSString *PNGFilePath = @"/my/dir/test.png";

#pragma mark - fileTypeForFile

-(void)testNilFileType {
    // given
    
    // when
    NSBitmapImageFileType fileType = fileTypeForFile(nil);
    
    // then
    STAssertTrue(fileType == NSTIFFFileType, @"");
}

-(void)testGifFileType {
    // given
    
    // when
    NSBitmapImageFileType fileType = fileTypeForFile(GIFFilePath);
    
    // then
    STAssertTrue(fileType == NSGIFFileType, @"");
}

-(void)testJPGFileType {
    // given
    
    // when
    NSBitmapImageFileType fileType = fileTypeForFile(JPGFilePath);
    
    // then
    STAssertTrue(fileType == NSJPEGFileType, @"");
}

-(void)testJPEGFileType {
    // given
    
    // when
    NSBitmapImageFileType fileType = fileTypeForFile(JPEGFilePath);
    
    // then
    STAssertTrue(fileType == NSJPEGFileType, @"");
}

-(void)testPNGFileType {
    // given
    
    // when
    NSBitmapImageFileType fileType = fileTypeForFile(PNGFilePath);
    
    // then
    STAssertTrue(fileType == NSPNGFileType, @"");
}

-(void)testPNGUppercaseFileType {
    // given
    
    // when
    NSBitmapImageFileType fileType = fileTypeForFile([PNGFilePath uppercaseString]);
    
    // then
    STAssertTrue(fileType == NSPNGFileType, @"");
}

#pragma mark - imageContentTypeForFile(NSString *file)

-(void)testNilContentType {
    // given
    
    // when
    CFStringRef imageContentType = imageContentTypeForFile(nil);
    
    // then
    STAssertTrue(imageContentType == kUTTypeImage, @"");
}


-(void)testGIFContentType {
    // given
    
    // when
    CFStringRef imageContentType = imageContentTypeForFile(GIFFilePath);
    
    // then
    STAssertTrue(imageContentType == kUTTypeGIF, @"");
}

-(void)testJPGContentType {
    // given
    
    // when
    CFStringRef imageContentType = imageContentTypeForFile(JPGFilePath);
    
    // then
    STAssertTrue(imageContentType == kUTTypeJPEG, @"");
}

-(void)testJPEGContentType {
    // given
    
    // when
    CFStringRef imageContentType = imageContentTypeForFile(JPEGFilePath);
    
    // then
    STAssertTrue(imageContentType == kUTTypeJPEG, @"");
}

-(void)testPNGContentType {
    // given
    
    // when
    CFStringRef imageContentType = imageContentTypeForFile(PNGFilePath);
    
    // then
    STAssertTrue(imageContentType == kUTTypePNG, @"");
}

-(void)testPNGUppercaseContentType {
    // given
    
    // when
    CFStringRef imageContentType = imageContentTypeForFile([PNGFilePath uppercaseString]);
    
    // then
    STAssertTrue(imageContentType == kUTTypePNG, @"");
}

#pragma mark - imageRepsWithContentsOfFile

-(void)testCompositedImageRepsWithTextReturnsImageArrayForValidBundlePNG {
    // given    
    NSString *imageFileName = [[NSBundle bundleForClass:[self class]] pathForResource:@"sms" ofType:@"png"];
    
    // when
    NSArray * imageReps = [NSBitmapImageRep imageRepsWithContentsOfFile:imageFileName];
    
    // then
    STAssertNotNil(imageReps, @"");
}

-(void)testCompositedImageRepsWithTextReturnsImageArrayForValidBundlePNG2x {
    // given
    NSString *imageFileName = [[NSBundle bundleForClass:[self class]] pathForResource:@"sms@2x" ofType:@"png"];
    
    // when
    NSArray * imageReps = [NSBitmapImageRep imageRepsWithContentsOfFile:imageFileName];
    
    // then
    STAssertNotNil(imageReps, @"");
}

#pragma mark - compositedImageRepsWithText

//NSData* compositedImageRepsWithText(NSArray *imageReps,
//                                    CFStringRef imageContentType,
//                                    NSString *text);

-(void)testCompositedImageRepsWithTextReturnsNilForNilArguments
{
    // given
    NSArray *imageReps = nil;
    CFStringRef imageContentType = nil;
    NSString *text = nil;
    
    // when
    NSData *imageData = compositedImageRepsWithText(imageReps, imageContentType, text);
    
    // then
    STAssertNil(imageData, @"");
}

-(void)testCompositedImageRepsWithTextReturnsNilForEmptyArguments
{
    // given
    NSArray *imageReps = @[];
    CFStringRef imageContentType = (__bridge CFStringRef)@"";
    NSString *text = @"";
    
    // when
    NSData *imageData = compositedImageRepsWithText(imageReps, imageContentType, text);
    
    // then
    STAssertNil(imageData, @"");
}

-(NSData *)performTestCompositedImageRepsWithTextReturnsValidImageDataWithFilenamePrefix:(NSString*)filePrefix
{
    // given
    NSString *imageFileName = [[NSBundle bundleForClass:[self class]] pathForResource:filePrefix ofType:@"png"];
    NSArray * imageReps = [NSBitmapImageRep imageRepsWithContentsOfFile:imageFileName];
    
    CFStringRef imageContentType = kUTTypePNG;
    
    NSString *text = @"v1.0 (10)";
    
    // when
    NSData *imageData = compositedImageRepsWithText(imageReps, imageContentType, text);
        
    return imageData;
}

-(void)testCompositedImageRepsWithTextReturnsValidImageDataWithValidPNGArguments {
    // given / when
    NSData *imageData = [self performTestCompositedImageRepsWithTextReturnsValidImageDataWithFilenamePrefix:@"sms"];
    
    // then
    STAssertNotNil(imageData, @"");
}

-(void)testCompositedImageRepsWithTextReturnsValidImageDataWithValidPNG2xArguments {
    // given / when
    NSData *imageData = [self performTestCompositedImageRepsWithTextReturnsValidImageDataWithFilenamePrefix:@"sms@2x"];
    
    // then
    STAssertNotNil(imageData, @"");    
}

// TODO: check that the image data we get actually appears to be modified from the original
//-(void)testCompositedImageRepsWithTextReturnsModifiedImageData {
//    // given
//    NSData *originalImageData = [originalImage dat]
//    
//    // when
//    NSData *imageData = [self performTestCompositedImageRepsWithTextReturnsValidImageDataWithFilenamePrefix:@"sms"];
//    
//    // then
//    STAssertNotNil(imageData, @"");
//}

@end
