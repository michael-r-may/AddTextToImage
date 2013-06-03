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

#import "main.h"

#import <SenTestingKit/SenTestingKit.h>

@interface mainTests : SenTestCase
@end


@implementation mainTests

-(void)testThatCallingMainWithEmptyArgumentsReturnsAFailCode {
    // given
    const char * argv[0];
    int argc = sizeof(argv) / sizeof(argv[0]);
    
    // when
    int result = main(argc, argv);
    
    // then
    STAssertTrue(result == EXIT_FAILURE, @"");
}

-(void)testThatCallingMainWithOnlyOneArgumentReturnsAFailCode {
    // given
    const char * argv[] = {"appname", "/users/Shared/image.png"};
    int argc = sizeof(argv) / sizeof(argv[0]);
    
    // when
    int result = main(argc, argv);
    
    // then
    STAssertTrue(result == EXIT_FAILURE, @"");
}

-(void)testThatCallingMainWithOnlyTwoArgumentsReturnsAFailCode {
    // given
    const char * argv[] = {"appname", "/users/Shared/image.png", "v1.1"};
    int argc = sizeof(argv) / sizeof(argv[0]);
    
    // when
    int result = main(argc, argv);
    
    // then
    STAssertTrue(result == EXIT_FAILURE, @"");
}

-(void)testThatCallingMainWithThreeArgumentsButAnInvalidImageSourceReturnsAFailCode {
    // given
    const char * argv[] = {"appname", "/users/Shared/image.png", "v1.1", "/Users/shared/image-adj.png"};
    int argc = sizeof(argv) / sizeof(argv[0]);
    
    // when
    int result = main(argc, argv);
    
    // then
    STAssertTrue(result == EXIT_FAILURE, @"");
}

-(void)testThatCallingMainWithThreeValidArgumentsReturnsASuccessCode {
    // given
    NSString *imageFileName = [[NSBundle bundleForClass:[self class]] pathForResource:@"sms" ofType:@"png"];
    const char *imageFileNameCString = [imageFileName cStringUsingEncoding:NSUTF8StringEncoding];
    const char *destinationFilename = tmpnam(NULL);
    const char * argv[] = {"appname", imageFileNameCString, "v1.1", destinationFilename};
    int argc = sizeof(argv) / sizeof(argv[0]);
    
    // when
    int result = main(argc, argv);
    
    // then
    STAssertTrue(result == EXIT_SUCCESS, @"");
}

-(void)testThatCallingMainWithFourValidArgumentsReturnsASuccessCode {
    // given
    NSString *imageFileName = [[NSBundle bundleForClass:[self class]] pathForResource:@"sms" ofType:@"png"];
    const char *imageFileNameCString = [imageFileName cStringUsingEncoding:NSUTF8StringEncoding];
    const char *destinationFilename = tmpnam(NULL);
    const char * argv[] = {"appname", imageFileNameCString, "v1.1", destinationFilename, "extraargument"};
    int argc = sizeof(argv) / sizeof(argv[0]);
    
    // when
    int result = main(argc, argv);
    
    // then
    STAssertTrue(result == EXIT_SUCCESS, @"");
}

-(void)testThatCallingMainWithThreeValidArgumentsInAPlistFileReturnsASuccessCode {
    // given
    NSString *imageFileName = [[NSBundle bundleForClass:[self class]] pathForResource:@"sms" ofType:@"png"];
    const char *imageFileNameCString = [imageFileName cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSString *plistFileName = [[NSBundle bundleForClass:[self class]] pathForResource:@"ATTIInfoPlistToVersionStringTests-InfoPlist" ofType:@"plist"];
    const char *plistFileNameCString = [plistFileName cStringUsingEncoding:NSUTF8StringEncoding];
    
    const char *destinationFilename = tmpnam(NULL);
    
    const char * argv[] = {"appname", imageFileNameCString, plistFileNameCString, destinationFilename};
    int argc = sizeof(argv) / sizeof(argv[0]);
    
    // when
    int result = main(argc, argv);
    
    // then
    STAssertTrue(result == EXIT_SUCCESS, @"");
}

@end
