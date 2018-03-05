# Add a view only role for incingaweb2
class profiles::monitoring::icingaweb2 (
   icingaweb2::config::role { 'View only':
      users       => 'Viewer',
      permissions => 'module/monitoring',
    }
  )
