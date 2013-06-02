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

#import "ATTIAddTextToImageUnitTests.h"

#import "ATTIAddTextToImage.h"

@implementation ATTIAddTextToImageUnitTests

NSString *GIFFilePath = @"/my/dir/test.gif";
NSString *JPGFilePath = @"/my/dir/test.jpg";
NSString *JPEGFilePath = @"/my/dir/test.jpeg";
NSString *PNGFilePath = @"/my/dir/test.png";

#pragma mark - fileTypeForFile

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

#pragma mark - imageContentTypeForFile(NSString *file)

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

@end
