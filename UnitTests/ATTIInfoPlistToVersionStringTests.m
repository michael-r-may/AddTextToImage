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

#import <SenTestingKit/SenTestingKit.h>

#import "ATTIInfoPlistToVersionString.h"


// hidden in ATTIInfoPlistToVersionString but needed so I can unit test it
NSString *versionStringFromAppVersionBuildNumber(NSString *appVersion, NSString* buildNumber);
NSString* versionStringFromDictionary(NSDictionary *infoPlistDictionary);


@interface ATTIInfoPlistToVersionStringTests : SenTestCase
@end

@implementation ATTIInfoPlistToVersionStringTests

-(void)testThatCallingVersionStringFromInfoPlistFilenameWithNilFilenameReturnsANilVersionString {
    // given
    NSString *plistFilename = nil;
    
    // when
    NSString* versionString = versionStringFromInfoPlistFilename(plistFilename);
    
    // then
    STAssertNil(versionString, @"");
}

-(void)testThatCallingVersionStringFromInfoPlistFilenameWithEmptyPListFilenameReturnsANilVersionString {
    // given
    NSString *plistFilename = [[NSBundle bundleForClass:[self class]] pathForResource:@"ATTIInfoPlistToVersionStringTests-Empty-InfoPlist" ofType:@"plist"];
    
    // when
    NSString* versionString = versionStringFromInfoPlistFilename(plistFilename);
    
    // then
    STAssertNil(versionString, @"");
}

-(void)testThatCallingVersionStringFromInfoPlistFilenameWithPListFilenameReturnsAVersionString {
    // given
    NSString *plistFilename = [[NSBundle bundleForClass:[self class]] pathForResource:@"ATTIInfoPlistToVersionStringTests-InfoPlist" ofType:@"plist"];
    
    // when
    NSString* versionString = versionStringFromInfoPlistFilename(plistFilename);
    
    // then
    STAssertNotNil(versionString, @"");
}

-(void)testThatCallingVersionStringFromInfoPlistFilenameWithPListFilenameReturnsTheRightVersionString {
    // given
    NSString *plistFilename = [[NSBundle bundleForClass:[self class]] pathForResource:@"ATTIInfoPlistToVersionStringTests-InfoPlist" ofType:@"plist"];
    
    // when
    NSString* versionString = versionStringFromInfoPlistFilename(plistFilename);
    
    // then
    STAssertEqualObjects(versionString, @"1.3 (11)", @"");
}

#pragma mark - NSString *versionStringFromAppVersionBuildNumber(NSString *appVersion, NSString* buildNumber);

-(void)testThatVersionStringFromAppVersionBuildNumberWhenBothNilReturnsNil {
    // given
    NSString *appVersion = nil;
    NSString *buildNumber = nil;
    
    // when
    NSString *versionString = versionStringFromAppVersionBuildNumber(appVersion, buildNumber);
    
    // then
    STAssertNil(versionString, @"");
}

-(void)testThatVersionStringFromAppVersionBuildNumberWhenBuildNumberIsNilReturnsJustAppVersion {
    // given
    NSString *appVersion = @"1.1";
    NSString *buildNumber = nil;
    
    // when
    NSString *versionString = versionStringFromAppVersionBuildNumber(appVersion, buildNumber);
    
    // then
    STAssertEqualObjects(versionString, appVersion, @"");
}

-(void)testThatVersionStringFromAppVersionBuildNumberWhenAppVersionIsNilReturnsJustBuildNumber {
    // given
    NSString *appVersion = nil;
    NSString *buildNumber = @"21";
    
    // when
    NSString *versionString = versionStringFromAppVersionBuildNumber(appVersion, buildNumber);
    
    // then
    NSString *expectedFormattedBuildNumber = @"(21)";
    STAssertEqualObjects(versionString, expectedFormattedBuildNumber, @"");
}

-(void)testThatVersionStringFromAppVersionBuildNumberReturnsValidVersionString {
    // given
    NSString *appVersion = @"1.4";
    NSString *buildNumber = @"21";
    
    // when
    NSString *versionString = versionStringFromAppVersionBuildNumber(appVersion, buildNumber);
    
    // then
    NSString *expectedVersionString = @"1.4 (21)";
    STAssertEqualObjects(versionString, expectedVersionString, @"");
}

#pragma mark - NSString* versionStringFromDictionary(NSDictionary *infoPlistDictionary);

-(void)testThatVersionStringFromDictionaryWithNilDictionaryReturnsNilVersionString {
    // given
    NSDictionary *plistDictionary = nil;
    
    // when
    NSString *versionString = versionStringFromDictionary(plistDictionary);
    
    // then
    STAssertNil(versionString, @"");
}

-(void)testThatVersionStringFromDictionaryWithEmptyDictionaryReturnsNilVersionString {
    // given
    NSDictionary *plistDictionary = @{};
    
    // when
    NSString *versionString = versionStringFromDictionary(plistDictionary);
    
    // then
    STAssertNil(versionString, @"");
}


@end
