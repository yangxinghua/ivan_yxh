### ActivityManagerService.startActivity --> startActivityAsUser(IApplicationThread caller, String callingPackage,Intent intent, String resolvedType, IBinder resultTo, String resultWho, int requestCode,int startFlags, ProfilerInfo profilerInfo, Bundle options, int userId)






### ActivityStackSupervisor.startActivityMayWait(IApplicationThread caller, int callingUid,String callingPackage, Intent intent, String resolvedType,IVoiceInteractionSession voiceSession, IVoiceInteractor voiceInteractor,IBinder resultTo, String resultWho, int requestCode, int startFlags,ProfilerInfo profilerInfo, WaitResult outResult, Configuration config,Bundle options, boolean ignoreTargetSecurity, int userId,IActivityContainer iContainer, TaskRecord inTask)





### ActivityStackSupervisor.startActivityLocked(IApplicationThread caller,Intent intent, String resolvedType, ActivityInfo aInfo,IVoiceInteractionSession voiceSession, IVoiceInteractor voiceInteractor,IBinder resultTo, String resultWho, int requestCode,int callingPid, int callingUid, String callingPackage,int realCallingPid, int realCallingUid, int startFlags, Bundle options,boolean ignoreTargetSecurity, boolean componentSpecified, ActivityRecord[] outActivity,ActivityContainer container, TaskRecord inTask)






###  ActivityStackSupervisor.startActivityUncheckedLocked(final ActivityRecord r, ActivityRecord sourceRecord,IVoiceInteractionSession voiceSession, IVoiceInteractor voiceInteractor, int startFlags,boolean doResume, Bundle options, TaskRecord inTask)






### ActivityStack.startActivityLocked(ActivityRecord r, boolean newTask,boolean doResume, boolean keepCurTransition, Bundle options)






### ActivityStackSupervisor.resumeTopActivitiesLocked(ActivityStack targetStack, ActivityRecord target,Bundle targetOptions)






### ActivityStack.resumeTopActivityLocked(ActivityRecord prev, Bundle options)







### ActivityStack.resumeTopActivityInnerLocked(ActivityRecord prev, Bundle options)







## ActivityStackSupervisorstartSpecificActivityLocked(ActivityRecord r,boolean andResume, boolean checkConfig)   






## ActivityStackSupervisor.realStartActivityLocked(ActivityRecord r,ProcessRecord app, boolean andResume, boolean checkConfig)
