class GetUrl {
  static const getCandidateDrivers = 'api/services/app/TripsService/GetCandidateDrivers';
  static const getAvailableTrips = 'api/services/app/TripsService/GetAvailableTrips';
  static const getPolicy = 'api/services/app/Settings/Getsettings';
  static const getSharedTrips =
      'api/services/app/SharedTripService/GetDriverFilteredTrips';

  static const getActiveTrips = 'api/services/app/TripsService/GetActiveTrip';

  static const tripById = 'api/services/app/TripsService/Get';

  static const getProfileInfo = 'api/services/app/UserService/Get';

  static const cancelReason = 'api/services/app/CancelReasons/GetAll';

  static const getFavoritePlaces =
      'api/services/app/FavirotePlacesAppServices/GetFavirotePlacesByUser';

  static const getDriverLocation = 'api/services/app/UserService/GetDriversLocation';

  static const getAllPoints = 'api/services/app/PointsService/GetAll';

  static const getConnectedPoints = 'api/services/app/PointsService/GetConnectedPoints';

  static const getPointsEdge = 'api/services/app/EdgesService/GetEdgeBetweenTwoPoints';

  static const getSharedTripById = 'api/services/app/SharedTripService/GetSharedTripById';
  static const getSharedTripByRequestId =
      'api/services/app/SharedTripService/GetSharedTripByRequestId';

  static const getPathById = 'api/services/app/PathService/GetPathById';

  static const driverAvailable = 'api/services/app/UserService/MakeDriverAavailable';

  static const driverUnAvailable = 'api/services/app/UserService/MakeDriverUnAavailable';

  static const myWallet = 'api/services/app/AccountsService/GetAccountBalance';

  static const debt = 'api/services/app/AccountsService/DriverDebts';

  static const allDrivers = 'api/services/app/User/GetAllDrivers';

  static const getDriverById = 'api/services/app/User/GetDriverById';

  static const driverRedeems = 'api/services/app/RedeemService/GetRedeems';
  static const allRedeems = 'api/services/app/RedeemService/GetAll';

  static const carCategories = 'api/services/app/CarCategoriesService/GetAll';

  static const bestDriver = 'api/services/app/User/GetBestDriver';
  static const getAllAdmins = 'api/services/app/User/getAllAdmins';
  static const driverFinancialReport =
      'api/services/app/AccountsService/DriverFinancialReport';

  static const allRoles = 'api/services/app/Role/GetAll';

  static const getAllClients = 'api/services/app/User/GetAllCustomars';

  static const getClientById = 'api/services/app/User/Get';
  static const pointById = 'api/services/app/PointsService/Get';

  static const getAllEdgesPoint = 'api/services/app/EdgesService/GetEdgesFromPoint';

  static const getAllEpay = 'api/services/app/EpaymentService/GetAll';

  static const getAllMessages = 'api/services/app/Messages/GetAll';

  static const getAllTransfers = 'api/services/app/AccountsService/GetAllTransfers';

  static const getTrips = 'api/services/app/TripsService/GetAllTrips';

  static const getAllSharedTrips = 'api/services/app/SharedTripService/GetAllSharedTrips';

  static const fromDriver = 'api/services/app/AccountsService/RequiredAmountFromDriver';

  static const fromCompany = 'api/services/app/AccountsService/DriverDebtFromCompany';

  static const getAllCoupons = 'api/services/app/Coupons/GetAll';

  static const allPermissions = 'api/services/app/Role/GetAllPermissions';

  static const institutions = 'api/services/app/InstitutiosnsService/GetAll';

  static const systemParams = 'api/services/app/SystemParametersService/GetAll';

  static const systemSettings = 'api/services/app/SystemSettingsService/GetAll';

  static const financialReport = 'api/services/app/AccountsService/FinancialReport';

  static const tempTrips = 'api/services/app/PathService/GetPaths';

  static const tempTripById = 'api/services/app/PathService/GetPathById';

  static const governorates = 'api/services/app/GovernorateService/GetAll';
  static const areas = 'api/services/app/AreaService/GetAll';
  static const allTickets = 'api/services/app/TicketsService/GetAll';

  static const getAgencyById = 'api/services/app/AgenciesService/Get';

  static const agencies = 'api/services/app/AgenciesService/GetAll';

  static const getDriversImei = 'api/services/app/User/GetDriversImes';

  static const tripDebit = 'api/services/app/DebitServices/getTripFinancialDetails';

  static const getHome = 'api/services/app/DashboardService/Index';

  static const driverStatusHistory = 'api/services/app/UserService/GetStatusHistory';

  static const companies = 'api/services/app/CompaniesService/GetAll';

  static const plans = 'api/services/app/PlansService/GetAll';

  static const agenciesFinancialReport =
      'api/services/app/AccountsService/AgenciesFinancialReports';

  static const agencyFinancialReport =
      'api/services/app/AccountsService/AgencyFinancialReport';

  static const companyPaths = 'api/services/app/CompanyPathService/GetAll';

  static const companyPathById = 'api/services/app/CompanyPathService/Get';

  static const planTrips = 'api/services/app/PlanTripsService/GetAll';

  static const planTripById = 'api/services/app/PlanTripsService/Get';
  static const gerAllSos = 'api/services/app/EmergencyService/GetAll';
  static const getCompanyTransfers =
      'api/services/app/AccountsService/GetCompanyTransfers';
  static const planAttendance = 'api/services/app/EnrollmentRecordService/GetAll';
}

class PostUrl {
  static const replayTicket = 'api/services/app/TicketsService/AddReplyToTicket';
  static const serverProxy = 'api/services/app/HttpRequestService/ExecuteRequest';
  static const requestOtp = 'api/Auth/RequestOTP';
  static const sendNotificaion =
      'api/services/app/SystemNotificationService/ProdcastNotification';
  static const signup = 'api/services/app/Account/Register';
  static const acceptPolicy = 'api/services/app/AcceptPolicy/Create';

  static const ratingDriver = 'api/services/app/UserService/PostRate';
  static const addFavoritePlace = 'api/services/app/FavirotePlacesAppServices/Create';

  static const sendNote = 'api/services/app/Messages/CreateMessageForUser';
  static const confirmCode = 'api/Auth/VerifyAndLogin';
  static const forgotPassword = 'api/services/app/Account/ForgetPassword';
  static const resendCode = 'api/Auth/ResendOTP';
  static const resetPassword = 'api/services/app/Account/ResetNewPassword';

  static const createSharedTrip = 'api/services/app/SharedTripService/CreateSharedTrip';
  static const createPath = 'api/services/app/PathService/CreatePath';
  static const lookingForDriver = 'api/services/app/UserService/LookingForDriver';

  static const insertFireBaseToken =
      'api/services/app/UserService/InsertFireBaseTokenForUser';

  static const mtnPaymentRequest = 'api/services/app/EpaymentService/MtnPaymentRequest';
  static const mtnSendOtp = 'api/services/app/EpaymentService/MtnDoPayment';

  static const chargeClient = 'api/services/app/AccountsService/ChargeClientAccount';

  static const login = 'api/TokenAuth/Authenticate';

  static const getPermissions = 'api/services/app/Role/GetUserPermissions';

  static const createRedeem = 'api/services/app/RedeemService/CreateRedeem';

  static const createDriver = 'api/services/app/User/CreateDriver';

  static const activateUser = "api/services/app/User/Activate";

  static const deactivateUser = "api/services/app/User/DeActivate";

  static const createReason = 'api/services/app/CancelReasons/Create';

  static const createCarCategory = 'api/services/app/CarCategoriesService/Create';

  static const createAdmin = 'api/services/app/User/Create';

  static const createPoint = 'api/services/app/PointsService/CreatePoint';

  static const createEdge = 'api/services/app/EdgesService/CreateEdge';

  static const createPolicy = 'api/services/app/Settings/Updatesettings';

  static const createFromDriver = 'api/services/app/PaymentService/CreatePayOffPayment';
  static const createToAgency =
      'api/services/app/PaymentService/CreateAgencyPayOffPayment';
  static const createFromCompany = 'api/services/app/PaymentService/CreateDebtPayment';
  static const createCoupon = 'api/services/app/Coupons/Create';

  static const createRole = 'api/services/app/Role/Create';

  static const createInstitution = 'api/services/app/InstitutiosnsService/Create';
  static const createTempTrip = 'api/services/app/PathService/CreatePath';

  static const estimateSharedTrip = 'api/services/app/PathService/GetPathEstimation';
  static const createGovernorate = 'api/services/app/GovernorateService/Create';
  static const createArea = 'api/services/app/AreaService/Create';

  static const createAgency = 'api/services/app/AgenciesService/Create';
  static const reverseCharging = 'api/services/app/AccountsService/ReverseCharging';

  static const createCompany = 'api/services/app/CompaniesService/Create';
  static const createPlan = 'api/services/app/PlansService/Create';

  static const createCompanyPath = 'api/services/app/CompanyPathService/Create';

  static const estimateCompanyPath =
      'api/services/app/PathService/GetPlansPathEstimation';

  static const createPlanTrip = 'api/services/app/PlanTripsService/Create';
}

class PutUrl {
  static const updateTrip = 'api/services/app/TripsService/UpdateStatus';

  static const updateGovernorate = 'api/services/app/GovernorateService/Update';
  static const updateArea = 'api/services/app/AreaService/Update';
  static const updateProfile = 'api/services/app/User/UpdateUser';
  static const updateDriver = 'api/services/app/User/UpdateDriver';

  static const updateFavoritePlace = 'api/services/app/FavirotePlacesAppServices/Update';
  static const changeUserLocation = 'api/services/app/UserService/ChangeUserLocation';

  static const updateCarCategory = 'api/services/app/CarCategoriesService/Update';

  static const updateAdmin = 'api/services/app/User/Update';

  static const updatePoint = 'api/services/app/PointsService/Update';

  static const updateEdge = 'api/services/app/EdgesService/Update';
  static const updateCoupon = 'api/services/app/Coupons/Update';
  static const updateRole = 'api/services/app/Role/Update';

  static const updateInstitution = 'api/services/app/InstitutiosnsService/Update';

  static const updateParams = 'api/services/app/SystemParametersService/Update';

  static const updateSetting = 'api/services/app/SystemSettingsService/Update';

  static const updateTempTrip = 'api/services/app/PathService/UpdatePath';

  static const updateAgency = 'api/services/app/AgenciesService/Update';

  static const updateCompany = 'api/services/app/CompaniesService/Update';
  static const updatePlan = 'api/services/app/PlansService/Update';

  static const updateCompanyPath = 'api/services/app/CompanyPathService/Update';

  static const updatePlanTrip = 'api/services/app/PlanTripsService/Update';
}

class DeleteUrl {
  static const deleteTempTrip = 'api/services/app/PathService/DeletePath';
  static const deleteFavoritePlace = 'api/services/app/FavirotePlacesAppServices/Delete';

  static const deleteCancelReason = 'api/services/app/CancelReasons/Delete';
  static const deleteCarCategory = 'api/services/app/CarCategoriesService/Delete';

  static const deleteEdge = 'api/services/app/EdgesService/RemoveEdge';

  static const deletePoint = 'api/services/app/PointsService/Delete';

  static const deleteRole = 'api/services/app/Role/Delete';

  static const deleteInstitution = 'api/services/app/InstitutiosnsService/Delete';

  static const deleteCancelGovernorate = 'api/services/app/GovernorateService/Delete';
  static const deleteCancelArea = 'api/services/app/AreaService/Delete';

  static const deleteCancelCoupon = 'api/services/app/Cupons/Delete';

  static const deleteCancelAgency = 'api/services/app/AgenciesService/Delete';

  static const deleteCompany = 'api/services/app/CompaniesService/Delete';
  static const deletePlan = 'api/services/app/PlansService/Delete';

  static const deleteCompanyPath = 'api/services/app/CompanyPathService/Delete';

  static const deletePlanTrip = 'api/services/app/PlanTripsService/Delete';
}

class OrsUrl {
  static const getRoutePoints = 'v2/directions/driving-car';
  static const getLocationName = 'geocode/reverse';
  static const hostName = 'api.openrouteservice.org';
  static const key = '5b3ce3597851110001cf6248989ba286fa3c483496378107c01120f3';
}

class OsrmUrl {
  static const getRoutePoints = 'route/v1/driving';
  static const getLocationName = 'reverse';
  static const hostName = 'router.project-osrm.org';
  static const hostOsmName = 'nominatim.openstreetmap.org';
  static const key = '5b3ce3597851110001cf6248989ba286fa3c483496378107c01120f3';
}

class PatchUrl {
  static const updateSharedTrip =
      'api/services/app/SharedTripService/UpdateSharedTripStatus';

  static const updateSharedTripTime =
      'api/services/app/SharedTripService/UpdateSharedTripTime';

  static const changeLoyalty = 'api/services/app/UserService/ChangeSubscriptionInLoyalty';

  static const changeProviderState =
      'api/services/app/EpaymentService/ChangeActiveStatus';

  static const changeCouponState = 'api/services/app/Coupons/ToggleActiveStatus';
}

String get baseUrl {
  return testUrl;
  // return liveUrl;
}

const liveUrl = 'live.qareeb-maas.com';
const testUrl = 'qareeb-api.first-pioneers.com.tr';
