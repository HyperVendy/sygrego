# Create the superuser
User.create(email: "registrations@stateyouthgames.com",
            password: Rails.application.credentials.su_password,
            password_confirmation: Rails.application.credentials.su_password)

# Create the singleton Setting record...
Setting.create if Setting.count == 0

# Create static page entries for the information and policy pages
Page.create(name: "About Us",
            permalink: "info",
            admin_use: true)
Page.create(name: "Terms and Conditions",
            permalink: "terms",
            admin_use: true)
Page.create(name: "Privacy Policy",
            permalink: "privacy",
            admin_use: true)
Page.create(name: "Participant Image Use Policy",
            permalink: "image",
            admin_use: true)

# Create the Admin group
Group.create(abbr: "ADM",
             name: "Administration team",
             short_name: "Admin",
             coming: true,
             admin_use: true,
             new_group: false,
             trading_name: "Administration team",
             address: "Lardner Park office",
             suburb: "Lardner",
             postcode: 3821,
             email: "info@stateyouthgames.com",
             phone_number: "0444 111 222",
             website: "https://stateyouthgames.com/vic",
             denomination: "Churches of Christ",
             status: "Approved",
             updated_by: 1
            )

# Create the Default group
Group.create(abbr: "DFLT",
             name: "I can't find my group",
             short_name: "No group",
             coming: true,
             admin_use: true,
             new_group: false,
             trading_name: "Choose this and we will help you",
             address: "Lardner Park office",
             suburb: "Lardner",
             postcode: 3821,
             email: "info@stateyouthgames.com",
             phone_number: "0444 111 222",
             website: "https://stateyouthgames.com/vic",
             denomination: "None",
             status: "Approved",
             updated_by: 1
            )