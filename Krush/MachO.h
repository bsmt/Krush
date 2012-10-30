//
//  MachO.h
//
//  Created by ████
//

#import <Foundation/Foundation.h>

#import "Header.h"
#import "Command.h"
#import "SegmentCommand.h"
#import "SymtabCommand.h"

#include <mach-o/loader.h>

/** MachO representation class. */

@interface MachO : NSObject

/// The MachO data found inside the binary.
@property NSData *data;

/// Starting offset of the object in the binary.
@property unsigned int location;

/// Target architecture of the MachO. i386 or x86_64.
@property cpu_type_t arch;

/// The header structure/object containing information about the MachO.
@property(retain) Header *header;

/// All of the segments the object is separated into.
@property NSMutableArray *segments;

/// Symbol table, contains information about functions if the binary isn't stripped.
@property SymtabCommand *symtab;


/// @name Initialization

-(MachO *)init;

/** Read a 32 bit MachO inside a binary.
 
 For most other features to work, this needs to be called as opposed to init, as this finds all of the needed information.
 
 @param off Offset at which the MachO begins in a binary.
 @param bin The Binary data to look in.
 @return A MachO with load commands and other information stored inside.
 @see x86_64ObjectAtOffset:inData:
 */
+(MachO *)i386ObjectAtOffset:(unsigned int)off inData:(NSData *)bin;

/** Read a 64 bit MachO inside a binary.
 
 For most other features to work, this needs to be called as opposed to init, as this finds all of the needed information.
 
 @param off Offset at which the MachO begins in a binary.
 @param bin The Binary data to look in.
 @return A MachO with load commands and other information stored inside.
 @see i386ObjectAtOffset:inData:
 */
+(MachO *)x86_64ObjectAtOffset:(unsigned int)off inData:(NSData *)bin;


/// @name Segments

/** Find a segment inside a 32 bit MachO.
 
 @param segname Name of the segment. E.g. __TEXT or __DATA
 @return A SegmentCommand object representing the segment found in the MachO
 @see segment64WithName:
 @see section:inSegment:
 @see section64:inSegment:
*/
-(SegmentCommand *)segmentWithName:(NSString *)segname;

/** Find a segment inside a 64 bit MachO.
 
 @param segname Name of the segment. E.g. __TEXT or __DATA
 @return A SegmentCommand object representing the segment found in the MachO
 @see segmentWithName:
 @see section:inSegment:
 @see section64:inSegment:
 */
-(SegmentCommand64 *)segment64WithName:(NSString *)segname;

/** Find a segment,section pair in a 32 bit MachO
 
 @param sectName Name of the section. E.g. __text or __const
 @return A Section object representing the section found in the MachO
 @see segmentWithName:
 @see segment64WithName:
 @see section64:inSegment:
 */
-(Section *)section:(NSString *)sectName inSegment:(NSString *)segName;

/** Find a segment,section pair in a 64 bit MachO
 
 @param sectName Name of the section. E.g. __text or __const
 @return A Section object representing the section found in the MachO
 @see segmentWithName:
 @see segment64WithName:
 @see section:inSegment:
 */
-(Section64 *)section64:(NSString *)sectName inSegment:(NSString *)segName;


/// @name Offset Conversion

/** Convert a virtual offset in the MachO to the file offset in its binary file.
 
 @param virtual The offset to convert.
 @return The file offset corresponding to the virtual offset.
 @see convertRealOffset:
 */
-(unsigned long)convertVirtualOffset:(unsigned long)virtual;

/** Convert a file offset to a virtual offset inside the MachO.
 
 @param real The file offset to convert.
 @return The virtual offset corresponding to the file offset.
 @see convertVirtualOffset:
 */
-(unsigned long)convertRealOffset:(unsigned long)real;

-(NSString *)description;

@end
