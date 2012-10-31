/**
 * ***************************************************************************
 * Copyright (c) 2010 Qcadoo Limited
 * Project: Qcadoo Framework
 * Version: 1.2.0-SNAPSHOT
 *
 * This file is part of Qcadoo.
 *
 * Qcadoo is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation; either version 3 of the License,
 * or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 * ***************************************************************************
 */
package com.qcadoo.maven.plugins.jetty;

import java.io.File;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.project.MavenProject;
import org.eclipse.jetty.util.resource.Resource;
import org.eclipse.jetty.util.resource.ResourceCollection;
import org.mortbay.jetty.plugin.JettyRunMojo;
import org.mortbay.jetty.plugin.JettyWebAppContext;
import org.mortbay.jetty.plugin.SystemProperties;
import org.mortbay.jetty.plugin.SystemProperty;
import org.springframework.util.ReflectionUtils;

/**
 * @goal jetty
 * @requiresDependencyResolution runtime
 * @execute phase="test-compile"
 */
public class JettyMojo extends JettyRunMojo {

    /**
     * @parameter
     * @required
     */
    private File jdbcDriver;

    /**
     * @parameter
     * @required
     */
    private String profile;

    /**
     * @parameter
     * @required
     */
    private File configuration;

    /**
     * @parameter
     * @required
     */
    private File logs;

    /**
     * @parameter
     * @required
     */
    private File temporaryPlugins;

    /**
     * @parameter
     * @required
     */
    private File plugins;

    /**
     * @parameter
     * @required
     */
    private File webapp;

    /**
     * @parameter
     * @required
     */
    private String restartCommand;

    /**
     * @parameter expression="${project}"
     * @readonly
     */
    private MavenProject _project;

    /**
     * @parameter expression="${maven.war.webxml}"
     * @readonly
     */
    private String _webXml;

    /**
     * @parameter expression="${project.build.outputDirectory}"
     * @required
     */
    private File _classesDirectory;

    /**
     * @parameter expression="${maven.war.src}"
     * @readonly
     */
    private File _webAppSourceDirectory;

    /**
     * @parameter expression="${plugin.artifacts}"
     * @readonly
     */
    @SuppressWarnings("rawtypes")
    private List _pluginArtifacts;

    /**
     * @parameter expression="${project.build.directory}/tmp"
     * @readonly
     */
    private File _tmpDirectory;

    @Override
    public void execute() throws MojoExecutionException, MojoFailureException {
        setField("scanTargets", new File[] { jdbcDriver });
        setField("project", _project);
        setField("webXml", _webXml);
        setField("classesDirectory", _classesDirectory);
        setField("webAppSourceDirectory", _webAppSourceDirectory);
        setField("pluginArtifacts", _pluginArtifacts);
        setField("reload", "automatic");
        setField("contextPath", "/");
        setField("tmpDirectory", _tmpDirectory);
        setField("scanIntervalSeconds", 0);

        try {
            FileUtils.forceMkdir(logs);
            FileUtils.forceMkdir(temporaryPlugins);
            FileUtils.forceMkdir(plugins);
        } catch (Exception e) {
            throw new MojoExecutionException(e.getMessage(), e);
        }

        SystemProperties systemProperties = new SystemProperties();
        systemProperties.setSystemProperty(getSystemProperty("spring.profiles.default", profile));
        systemProperties.setSystemProperty(getSystemProperty("QCADOO_CONF", configuration.getAbsolutePath()));
        systemProperties.setSystemProperty(getSystemProperty("QCADOO_LOG", logs.getAbsolutePath()));
        systemProperties.setSystemProperty(getSystemProperty("QCADOO_PLUGINS_TMP_PATH", temporaryPlugins.getAbsolutePath()));
        systemProperties.setSystemProperty(getSystemProperty("QCADOO_PLUGINS_PATH", plugins.getAbsolutePath()));
        systemProperties.setSystemProperty(getSystemProperty("QCADOO_WEBAPP_PATH", webapp.getAbsolutePath()));
        systemProperties.setSystemProperty(getSystemProperty("QCADOO_RESTART_CMD", restartCommand));
        setSystemProperties(systemProperties);

        try {
            JettyWebAppContext webAppConfig = new JettyWebAppContext();
            webAppConfig.setContextPath("/");

            List<Resource> resources = new ArrayList<Resource>();
            resources.add(Resource.newResource(webapp.getAbsolutePath()));
            resources.add(Resource.newResource("${basedir}/../../../qcadoo/qcadoo-view/src/main/resources"));
            resources.add(Resource.newResource("${basedir}/../../mes-plugins/mes-plugins-plugin-management/src/main/resources"));
            resources.add(Resource.newResource("${basedir}/../../mes-plugins/mes-plugins-technologies/src/main/resources"));
            webAppConfig.setBaseResource(new ResourceCollection(resources.toArray(new Resource[resources.size()])));
        } catch (Exception e) {
            throw new MojoExecutionException(e.getMessage(), e);
        }

        super.execute();
    }

    private SystemProperty getSystemProperty(final String name, final String value) {
        SystemProperty systemProperty = new SystemProperty();
        systemProperty.setKey(name);
        systemProperty.setName(name);
        systemProperty.setValue(value);
        return systemProperty;
    }

    private void setField(final String name, final Object value) {
        Field field = ReflectionUtils.findField(getClass(), name);
        ReflectionUtils.makeAccessible(field);
        ReflectionUtils.setField(field, this, value);
    }

}
