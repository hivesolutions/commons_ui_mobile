// Hive Mobile
// Copyright (c) 2008-2020 Hive Solutions Lda.
//
// This file is part of Hive Mobile.
//
// Hive Mobile is free software: you can redistribute it and/or modify
// it under the terms of the Apache License as published by the Apache
// Foundation, either version 2.0 of the License, or (at your option) any
// later version.
//
// Hive Mobile is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// Apache License for more details.
//
// You should have received a copy of the Apache License along with
// Hive Mobile. If not, see <http://www.apache.org/licenses/>.

// __author__    = João Magalhães <joamag@hive.pt>
// __version__   = 1.0.0
// __revision__  = $LastChangedRevision$
// __date__      = $LastChangedDate$
// __copyright__ = Copyright (c) 2008-2020 Hive Solutions Lda.
// __license__   = Apache License, Version 2.0

#import "Dependencies.h"

/**
 * Enumeration defining the various remote
 * serializer engines.
 */
typedef enum {
    HMRemoteTableViewNoneSerialized = 1,
    HMRemoteTableViewJsonSerialized,
    HMRemoteTableViewXmlSerialized,
} HMRemoteTableViewSerialized;


/**
 * The provider class to be used in the remote
 * table view.
 */
@protocol HMRemoteTableViewProvider<NSObject>

@required

/**
 * Retrieves the remote url to be used during the
 * provider series.
 *
 * @return The remote url to be used during the
 * provider series.
 */
- (NSString *)getRemoteUrl;

/**
 * Retrieves the type of serializer to be used to decode
 * the remote request.
 *
 * @return The type of serializer to be used to decode
 * the remote request
 */
- (HMRemoteTableViewSerialized)getRemoteType;

/**
 * Retrieves the item name to be used
 * to define the item.
 *
 * @return The item name to be used
 * to define the item.
 */
- (NSString *)getItemName;

/**
 * Retrieves the item title name to be used
 * to retrieve the item title.
 *
 * @return The item title name to be used
 * to retrieve the item title.
 */
- (NSString *)getItemTitleName;

@end
