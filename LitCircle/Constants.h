//
//  Constants.h
//  LitCircle
//
//  Created by Afzal Sheikh on 12/10/16.
//  Copyright © 2016 Afzal Sheikh. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


#define kGooglePlacesApiKey   @"AIzaSyCI360uRDPFNSzQzN4It8iJqzRthG0AK7w"

#define kServerURLLive   @"http://whatislitcircle.com/api/public/"
#define kServerImageURL   @""
#define kServerURL      kServerURLLive
#define kServerURLLogin kServerURL                      @"user"
#define kServerVideoURL kServerURL                      @"uploads/videos/"
#define kServerLikeVideoURL kServerURL                      @"post/like/"
#define kServerUnLikeVideoURL kServerURL                      @"post/unlike/"
#define kServerURLGETPosts kServerURL                      @"posts"
#define kServerURLGETCirclesPosts kServerURL                      @"posts/circle"
#define kServerURLGETComments kServerURL                      @"post/comments"
#define kServerURLPostComment kServerURL                      @"post/comment"
#define kServerURLGETNotifications kServerURL                      @"notifications/"
#define kServerURLGETActivities kServerURL                      @"activities/"

#define kServerURLCreateCircle kServerURL                      @"circle/create"
#define kServerURLCreateEvent kServerURL                      @"event/create"
#define kServerURLAttendVideo kServerURL                      @"attend"
#define kServerURLRejectRequest kServerURL                      @"/event/reject"
#define kServerURLAcceptRequest kServerURL                      @"/event/accept"



#define kServerURLJoinRequest kServerURL                      @"event/join"

#define kServerURLGETEvent kServerURL                      @"events"
#define kServerURLGETEventRequest kServerURL                      @"event/requests/"
#define kServerURLGETEventDetail kServerURL                      @"event"
#define kServerURLSearchCircle kServerURL                      @"circle/"
#define kServerURLUpdateCircle kServerURL                      @"circle/update/"
#define kServerURLPostVideo kServerURL                      @"post/upload"
#define kServerGetAllUsers kServerURL                      @"users"
#define kServerLogout kServerURL                      @"logout"


typedef enum{
    kServerRequestTypeLogin = 1,
    kServerRequestTypeSignUp = 2,
    kServerRequestTypeSaveRoute = 3,
} kServerRequestType;

#define kDefaultZoomLevel @"15"

#define kErrorMessage @"Something went wrong please try again later"

#define kUserName @"username"

#define kUserID @"user_id"
#define kUserToken @"userToken"
#define kFriebaseToken @"fireBaseToken"

#endif /* Constants_h */
