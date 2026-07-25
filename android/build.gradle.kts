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
    project.evaluationDependsOn(":app")
    
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
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
