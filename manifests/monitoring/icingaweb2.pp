# Add a view only role for incingaweb2

   icingaweb2::config::role { 'View only':
      users       => 'Viewer',
      permissions => 'module/monitoring',
    }
