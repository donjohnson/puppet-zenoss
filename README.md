puppet-zenoss
==============

Description
-----------

A Puppet report handler for creating Zenoss events from failed runs to
[zenoss](http://www.zenoss.com).  It includes sending all log data.

Requirements
------------

* `xmlrpc/client`
* `yaml`
* `puppet`

Installation & Usage
-------------------

1.  Ensure you have the required gems installed on your Puppet Master.

2.  Install puppet-zenoss as a module in your Puppet master's module
    path.

3.  Update the `zenoss_user`, `zenoss_pass`, `zenoss_server`, `zenoss_xmlrpc_port`, `zenoss_component`, and `zenoss_eventclass` variables 
    in the `zenoss.yaml` file according to your Zenoss configuration. 
    Copy the file to `/etc/puppet/`.
    An example file is included.

4.  Enable pluginsync and reports on your master and clients in `puppet.conf`

        [master]
        report = true
        reports = zenoss
        pluginsync = true
        [agent]
        report = true
        pluginsync = true

5.  Run the Puppet client and sync the report as a plugin

Author
------

Don Johnson <auderive@gmail.com>

Acknowledgments
------

Based on [puppet-zendesk](https://github.com/jamtur01/puppet-zendesk) by James Turnbull <james@lovedthanlost.net>, aka @kartar on Twitter. Thanks James!

License
-------

    Author:: Don Johnson <auderive@gmail.com>
    Copyright:: Copyright (c) 2011 Don Johnson
    License:: Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
