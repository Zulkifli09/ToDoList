allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    // Fix for legacy plugins (like isar_flutter_libs) that don't specify a namespace
    afterEvaluate {
        val androidExtension = extensions.findByName("android")
        if (androidExtension != null) {
            val namespaceProperty = androidExtension::class.java.methods.find { it.name == "getNamespace" }
            val setNamespaceMethod = androidExtension::class.java.methods.find { it.name == "setNamespace" }
            if (namespaceProperty != null && setNamespaceMethod != null) {
                val currentNamespace = namespaceProperty.invoke(androidExtension)
                if (currentNamespace == null) {
                    val groupName = project.group.toString()
                    if (groupName.isNotEmpty()) {
                        setNamespaceMethod.invoke(androidExtension, groupName)
                    } else {
                        setNamespaceMethod.invoke(androidExtension, "com.example.${project.name.replace("-", "_")}")
                    }
                }
            }
            
            // Force compileSdk to 36 to satisfy new Android plugins requirements
            val setCompileSdkMethod = androidExtension::class.java.methods.find { it.name == "setCompileSdkVersion" && it.parameterCount == 1 && it.parameterTypes[0].name == "int" } 
                ?: androidExtension::class.java.methods.find { it.name == "setCompileSdk" && it.parameterCount == 1 && it.parameterTypes[0].name == "java.lang.Integer" }
            if (setCompileSdkMethod != null) {
                setCompileSdkMethod.invoke(androidExtension, 36)
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
