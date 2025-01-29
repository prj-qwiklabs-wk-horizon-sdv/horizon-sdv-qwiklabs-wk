# Android CTS Build

The following provides examples of the environment variables and Jenkins build parameters in order to build Android
Automotive Compatibility Test Suite ([CTS](https://source.android.com/docs/compatibility/cts)) test harness.

# Environment Variables/Parameters

## AAOS_GERRIT_MANIFEST_URL

This provides the URL for the Android repo manifest. Such as:

* https://dev.horizon-sdv.scpmtk.com/android/platform/manifest (default)
* https://android.googlesource.com/platform/manifest

## AAOS_REVISION

The Android revision, ie branch or tag to build. Such as:

* horizon/android-14.0.0_r30 (ap1a - default)
* android14-qpr1-automotiveos-release
* android-14.0.0_r22
* android-14.0.0_r30 (ap1a)
* android-14.0.0_r74 (ap2a, refer to Known Issues)
* android-15.0.0_r4 (ap3a)
* android-15.0.0_r10 (ap4a)

## AAOS_LUNCH_TARGET

The Android cuttlefish target to build CTS from.

Reference: [Codenames, tags, and build numbers](https://source.android.com/docs/setup/reference/build-numbers)

Examples:

- Virtual Devices:
    -   `aosp_cf_x86_64_auto-userdebug`
    -   `aosp_cf_x86_64_auto-ap1a-userdebug`
    -   `aosp_cf_x86_64_auto-ap2a-userdebug`
    -   `aosp_cf_x86_64_auto-ap3a-userdebug`
    -   `aosp_cf_x86_64_auto-ap4a-userdebug`
    -   `aosp_cf_arm64_auto-userdebug`
    -   `aosp_cf_arm64_auto-ap1a-userdebug`
    -   `aosp_cf_arm64_auto-ap2a-userdebug`
    -   `aosp_cf_arm64_auto-ap3a-userdebug`
    -   `aosp_cf_arm64_auto-ap4a-userdebug`

## AAOS_CLEAN

Option to clean the build workspaace, either fully or simply for the `AAOS_LUNCH_TARGET` target defined.

## GERRIT_REPO_SYNC_JOBS

This is the value used for parallel jobs for `repo sync`, ie `-j <GERRIT_REPO_SYNC_JOBS>`.
The default is defined in system environment variable: `REPO_SYNC_JOBS`.
The minimum is 1 and the maximum is 24.

## INSTANCE_RETENTION_TIME

Keep the build VM instance and container running to allow user to connect to it. Useful for debugging build issues, determining target output archives etc.

Access using `kubectl` e.g. `kubectl exec -it -n jenkins <pod name> -- bash` from `bastion` host.

## AAOS_ARTIFACT_STORAGE_SOLUTION

Define storage solution used to push artifacts.

Currently `GCS_BUCKET` default pushes to GCS bucket, if empty then nothing will be stored.

## GERRIT_PROJECT / GERRIT_CHANGE_NUMBER / GERRIT_PATCHSET_NUMBER

These allow the user to fetch a specific Gerrit patchset.

# KNOWN ISSUES

Refer to workloads/android/pipelines/builds/aaos_builder/README.md.
