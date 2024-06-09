# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

tags = [
  'JavaScript', 'Python', 'Ruby', 'Java', 'C#', 'PHP', 'TypeScript', 'Swift', 'Kotlin', 'Go',
  'HTML', 'CSS', 'React', 'Angular', 'Vue.js', 'Node.js', 'Django', 'Flask', 'Ruby on Rails', 'ASP.NET',
  'MySQL', 'PostgreSQL', 'MongoDB', 'SQLite', 'Redis', 'Firebase', 'Cassandra',
  'Docker', 'Kubernetes', 'Jenkins', 'CI/CD', 'AWS', 'Azure', 'Google Cloud', 'Terraform',
  'Agile', 'Scrum', 'TDD (Test-Driven Development)', 'BDD (Behavior-Driven Development)', 'Pair Programming', 'Continuous Integration', 'Continuous Deployment',
  'Git', 'GitHub', 'GitLab', 'Bitbucket',
  'Visual Studio Code', 'IntelliJ IDEA', 'PyCharm', 'WebStorm', 'Sublime Text', 'Vim', 'Emacs',
  'Android', 'iOS', 'Flutter', 'React Native', 'SwiftUI', 'Kotlin Multiplatform',
  'Pandas', 'NumPy', 'TensorFlow', 'PyTorch', 'Scikit-Learn', 'Keras', 'Jupyter Notebook', 'R',
  'Encryption', 'Penetration Testing', 'Vulnerability Assessment', 'Firewalls', 'Network Security', 'Ethical Hacking', 'OWASP'
]

tags.each do |tag|
  Tag.find_or_create_by(name: tag)
end

puts "Seeded #{tags.size} tags."

