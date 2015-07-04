namespace java com.eleme.thriftServer

// 现在发现i64的时间秒数传不过来， 改为string传参，但仍表示秒数
typedef string Timestamp

enum AuroraErrorCode {

    UNKNOWN_ERROR  = 0,

    // UserErrors
    PONG_NOT_FOUND = 1,
    SHIPPING_ORDER_NOT_FOUND = 2,
    SHIPPING_ORDER_STATE_CANT_PROCESS = 3,
    SHIPPING_ORDER_OPTION_UNDEFINED = 4,
    SHIPPING_ORDER_INVALID_ATTRIBUTE = 5,
    SHIPPING_ORDER_ALREADY_EXIST = 6,
    SHIPPING_ORDER_REASON_CODE_CANT_PROCESS = 7,
    SHIPPING_ORDER_CALLCED_BY_CARRIER = 8,
    
    // SystemErrors
    DATABASE_ERROR = 999,

}

enum OrderType{
   // '配送业务
    NORMAL_ORDER = 1            // 1:  正常订单， 立即取货送货
    SCHEDULE_ORDER = 2       // 2:  预订单，预约配送
}

enum PayMethod{
    PAY_OFFLINE = 1                 // 1：现金，
    PAY_ONLINE = 2                  //  2：在线付款',
}
enum ShippingOrderMiscCategory{
    ORDER_MISC_CATEGORY_FOOD = 1
    ORDER_MISC_CATEGORY_DELIVER_FEE = 2
    ORDER_MISC_CATEGORY_COUPON = 3
    ORDER_MISC_CATEGORY_HUANBAO = 4
    ORDER_MISC_CATEGORY_FREE_COCA = 5
    ORDER_MISC_CATEGORY_DISCOUNT8 = 6
    ORDER_MISC_CATEGORY_NEW_USER_DISCOUNT = 7
    ORDER_MISC_CATEGORY_COCA_GIFT = 8
    ORDER_MISC_CATEGORY_DISCOUNT_88 = 9
    ORDER_MISC_CATEGORY_PULPY = 10
    ORDER_MISC_CATEGORY_FOOD_ACTIVITY = 11
    ORDER_MISC_CATEGORY_RESTAURANT_ACTIVITY = 12
    ORDER_MISC_CATEGORY_EXTRA_DISCOUNT = 100
    ORDER_MISC_CATEGORY_OLPAYMENT_DISCOUNT = 101
    ORDER_MISC_CATEGORY_PACKING_FEE = 102
    ORDER_MISC_CATEGORY_TPD_VIP_NO_DELIVER_FEE = 103
    ORDER_MISC_CATEGORY_OTHER_COMPENSATION = 105
    ORDER_MISC_CATEGORY_OVERTIME_COMPENSATION = 106
}

enum ShippingOrderStatus {

    DELIVERY_STATUS_DEFAULT = 0,           // '待分配'
    DELIVERY_STATUS_SCHEDULE = 1           // 预约配送

    DELIVERY_STATUS_CONFIRMING = 10,       // '待确认',
    DELIVERY_STATUS_CONFIRMED = 20,        // '待取餐',
    DELIVERY_STATUS_DELIVERING = 30,       // '配送中',
    DELIVERY_STATUS_SUCCESSED = 40,        // '配送成功',

    // 5: ['配送失败', '餐厅原因', '用户原因', '配送原因'],
    DELIVERY_STATUS_FAILED = 50,                   // '配送失败',
    DELIVERY_STATUS_FAILED_MERCHANT = 51,          // '餐厅原因',
    DELIVERY_STATUS_FAILED_CARRIER = 52,           // '配送原因',
    DELIVERY_STATUS_FAILED_USER = 53,              // '用户原因,

    // 6: ['配送取消', '商户取消', '配送方取消', '饿了么取消'],
    DELIVERY_STATUS_CANCELLED = 60,                // '配送取消',
    DELIVERY_STATUS_CANCELLED_MERCHANT = 61,       // '商户取消',
    DELIVERY_STATUS_CANCELLED_CARRIER = 62,        // '配送方取消',
    DELIVERY_STATUS_CANCELLED_USER = 63,           // '用户取消',

    DELIVERY_STATUS_EXCEPTION = 70,        // '投递异常'
}

struct TShippingOrder {
    1: required i64 id,
    2: required string tracking_id,

    # Platform
    3: required i32 platform_id,
    4: required string platform_name,
    5: required string platform_tracking_id,
    6: required Timestamp platform_created_time,

    # Merchant.
    7: required string platform_merchant_id,
    8: required string platform_merchant_name,

    # Carrier.
    9: required i32 carrier_id,
    10: required string carrier_name,
    11: required string carrier_tracking_id,
    12: required Timestamp carrier_assignment_time,
    13: required string carrier_driver_name,
    14: required string carrier_driver_phone,

    # Deliver Info.
    15: required OrderType shipping_option,
    16: required Timestamp schedule_delivery_time,
    17: required Timestamp promised_delivery_time,
    18: required string customer_remark,
    19: required string merchant_remark,
    20: required bool is_invoiced,
    21: required string invoice_title,

    # Shipping order state
    22: required i32 shipping_state,
    23: required i32 shipping_reason_code,

    # Items.
    24: required string item_description,

    25: required Timestamp created_at,
    26: required Timestamp updated_at,

}

struct TMerchantSegment {
    # TODO
}

struct TConsumerSegment {
    # TODO
}

struct TAddress {
    1: required string text,
    2: optional string district,
    3: optional string city_name,
    4: optional string city_code,
}

struct TLocation {
    1: optional string geohash,
    2: optional string longitude,
    3: optional string latitude,
}

struct TPlatformInfo {
    1: required i32 platform_id,
    2: optional string platform_name,
    3: required string platform_tracking_id,
    4: required string platform_merchant_seq,
    5: required Timestamp platform_created_time,
}

struct TCarrierInfo {
    1: required i32 carrier_id,
    2: optional string carrier_name,
    3: required string carrier_tracking_id,
}

struct TCarrierDriverInfo{
    1: required string carrier_driver_name,
    2: required string carrier_driver_phone,
}

struct TProcessInfo{
    1: required i32 to_state,
    2: required i32 reason_code,
    3: optional string remark,
    4: optional TCarrierInfo carrier_info,
    5: optional TCarrierDriverInfo driver_info,
    6: required Timestamp occured_time,
}

struct TAccountInfo {
    //  customer 不存在accound_id,  所以其实就是platform_merchant_id
    1: required string account_id,
    2: required string contact_name,
    // 用户实际应付总价格（有折扣）
    3: required double amount,
    4: required PayMethod payment_method,
    5: required TAddress address,
    6: required TLocation location,
    7: required string phone,
    8: optional string phone_2nd,
}

struct TOrderOption {
    1: required OrderType shipping_option,
    // 订单的实际总价格（无折扣）
    2: required double total_price,
    3: optional Timestamp schedule_delivery_time,
    4: optional Timestamp promised_delivery_time,
    5: optional string merchant_remark,
    6: optional string consumer_remark,
    7: required bool is_invoiced,
    8: optional string invoice_title,
}

struct TOrderItemAddition {
    1: required i32 category_id,
    2: required string name,
    3: required double price,
    4: required i32 quantity,
}

struct TOrderItem {
    1: required string name,
    2: required double price,
    3: required i32 quantity,
    4: optional list<TOrderItemAddition> additions,
}

# Exceptions

exception AuroraUserException {
    1: required AuroraErrorCode error_code,
    2: required string error_name,
    3: optional string message,
}

exception AuroraSystemException {
    1: required AuroraErrorCode error_code,
    2: required string error_name,
    3: optional string message,
}

exception AuroraUnknownException {
    1: required AuroraErrorCode error_code,
    2: required string error_name,
    3: optional string message,
}

/**
 * Services
**/

service AuroraService {

    string ping()
        throws (1: AuroraUserException user_exception,
                2: AuroraSystemException system_exception,
                3: AuroraUnknownException unknown_exception),

    /*
    **  Base Apis
    */
    string generate_shipping_order(1: TPlatformInfo platform_info,
             2: TAccountInfo merchant_info,
             3: TAccountInfo consumer_info,
             4: TOrderOption option,
             5: list<TOrderItem> order_items,
             6: list<TOrderItemAddition> misc)
        throws (1: AuroraUserException user_exception,
                2: AuroraSystemException system_exception,
                3: AuroraUnknownException unknown_exception),

    # 下单，merchant integration service.
    i64 push(1: TPlatformInfo platform_info,
             2: TAccountInfo merchant_info,
             3: TAccountInfo consumer_info,
             4: TOrderOption option,
             5: list<TOrderItem> order_items,
             6: list<TOrderItemAddition> misc)
        throws (1: AuroraUserException user_exception,
                2: AuroraSystemException system_exception,
                3: AuroraUnknownException unknown_exception),

    # 状态更新，merchant integration service.
    bool platform_process(1: string tracking_id,
                          2: i32 to_state,
                          3: i32 reason_code,
                          4: string remark)
        throws (1: AuroraUserException user_exception,
                2: AuroraSystemException system_exception,
                3: AuroraUnknownException unknown_exception),

    # 通过供应商id更新状态，merchant integration service.
    bool platform_process_by_tracking_id(1: i32 platform_id,
                                         2: string platform_tracking_id,
                                         3: i32 to_state,
                                         4: i32 reason_code,
                                         5: string remark)
        throws (1: AuroraUserException user_exception,
                2: AuroraSystemException system_exception,
                3: AuroraUnknownException unknown_exception),

    # 状态更新, carrier integration service.
    bool carrier_process(1: i64 order_id,
                         2: TProcessInfo process_info)
        throws (1: AuroraUserException user_exception,
                2: AuroraSystemException system_exception,
                3: AuroraUnknownException unknown_exception),

    # 通过配送商id更新状态, carrier integration service.
    bool carrier_process_by_tracking_id(1: i32 carrier_id,
                                        2: string carrier_tracking_id,
                                        3: TProcessInfo process_info)
        throws (1: AuroraUserException user_exception,
                2: AuroraSystemException system_exception,
                3: AuroraUnknownException unknown_exception),

    /*
    **  Query Apis
    */

    # 通过内部id获取
    TShippingOrder get(1: i64 id)
        throws (1: AuroraUserException user_exception,
                2: AuroraSystemException system_exception,
                3: AuroraUnknownException unknown_exception),

    # 通过tracking_id获取
    TShippingOrder get_by_tracking_id(1: string tracking_id)
        throws (1: AuroraUserException user_exception,
                2: AuroraSystemException system_exception,
                3: AuroraUnknownException unknown_exception),

    # 通过供应商id获取时间最近的一张运单
    TShippingOrder get_by_platform(1: i32 platform_id,
                                   2: string platform_tracking_id)
        throws (1: AuroraUserException user_exception,
                2: AuroraSystemException system_exception,
                3: AuroraUnknownException unknown_exception),

    # 通过配送商id获取时间最近的一张运单
    TShippingOrder get_by_carrier(1: i32 carrier_id,
                                  2: string carrier_tracking_id)
        throws (1: AuroraUserException user_exception,
                2: AuroraSystemException system_exception,
                3: AuroraUnknownException unknown_exception),
}
