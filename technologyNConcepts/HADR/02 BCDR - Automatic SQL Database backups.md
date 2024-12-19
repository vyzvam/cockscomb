# Business Continuity with Azure SQL Database

Learn about the additional mechanisms to recover from the disruptive events that cannot
be handled by SQL Database high availability architecture, such as

* Temporal tables enable you to restore row versions from any point in time.
* Built-in automated backups and Point in Time Restore enables you to restore complete database to some point in time within the last 35 days.
* You can restore a deleted database to the point at which it was deleted if the logical server has not been deleted.
* Long-term backup retention enables you to keep the backups up to 10 years.
* Auto-failover group allows the application to automatically recovery in case of a data center scale outage.

## Automatic SQL Database backups

SQL Database uses SQL Server technology to create full, differential, and transaction log backups for the purposes of Point-in-time restore (PITR).
The backups are stored in RA-GRS storage blobs that are replicated to a paired data center for protection against a data center outage.
When restoring, the service figures out which full, differential, and transaction log backups need to be restored.

* SQL Database automatically creates database backups
* Uses Azure read-access geo-redundant storage (RA-GRS) to provide geo-redundancy.
* Can configure a long-term backup retention policy.

## You can use these backups to

* Restore a database to a point-in-time within the retention period, create a new database in the same server as the original database.
* Restore a deleted database to the time it was deleted or any time within the retention period. can only be restored in the same server where the original database was created.
* Restore a database to another geographical region. This allows you to recover from a geographic disaster when you cannot access your server and database.
* Restore a database from a specific long-term backup (LTR)

## How long are backups kept

* Each SQL Database backup has a default retention period based
  service tier of the database, Differs between the DTU-based and the vCore-based purchasing model.
* If database deleted, SQL Database will keep the backups in the same way it would for an online database.
  For example, if you delete a Basic database that has a retention period of seven days,
  a backup that is four days old is saved for three more days.

## PITR retention period forDTU-based purchasing model

* Basic 1 week.
* Standard 5 weeks.
* Premium 5 weeks.

## How often do backups happen

The first full backup is scheduled immediately after a database is created.
It usually completes within 30 minutes, but it can take longer when the database is of a significant size.
For example, the initial backup can take longer on a restored database or a database copy.

* Backups for point-in-time restore
* Full database backups are created weekly
* Differential database backups are generally created every 12 hours
* Transaction log backups are generally created every 5 - 10 minutes

The PITR backups are geo-redundant and protected by Azure Storage cross-regional replication.

## Are backups encrypted

When TDE is enabled for an Azure SQL database, backups are also encrypted.
All new Azure SQL databases are configured with TDE enabled by default.
For more information on TDE, see Transparent Data Encryption with Azure SQL Database.

## How does Microsoft ensure backup integrity

### Azure SQL Database engineering team automatically tests the restore of automated database backups of databases across the service

Upon restore, databases also receive integrity checks using DBCC CHECKDB.
Any issues found during the integrity check will result in an alert to the engineering team. For more information about data integrity in Azure SQL Database,

### Extensive data integrity error alert monitoring

Backup and restore integrity checks.
I/O system “lost write” detection. tracks page writes and their associated LSNs (Log Sequence Numbers). Any subsequent read of a data page from disk will be compared with the page’s expected LSN. If there is a mismatch in LSNs between what is on disk and what is expected, the page will be considered stale, resulting in an immediate alert to the engineering team.

### Automatic Page Repair

leverages database replicas,
same technology used for SQL Server database mirroring and availability groups.
If a replica cannot read a page due to a data integrity issue,
a fresh copy of the page will be retrieved from another replica,
replacing the unreadable page without data loss or customer downtime.
This functionality applies to premium tier databases and standard tier databases with geo-secondaries.
Data integrity at rest and in transit. Databases created in the service are by default set to verify pages with the CHECKSUM setting, calculating the checksum over the entire page and storing in the page header. Transport Layer Security (TLS) is also used for all communication in addition to the base transport level checksums provided by TCP/IP.

## RA-GRS

* Maximizes availability for your storage account.
* Geo-replication across two regions.
* The secondary endpoint appends the suffix –secondary to the account name.
* The access keys for your storage account are the same for both the primary and secondary endpoints.

### considerations

Your application has to manage which endpoint it is interacting with when using RA-GRS.
Asynchronous replication involves a delay, changes that haven't yet been replicated to the secondary region may be lost if data can't be recovered from the primary region.

### Last Sync Time

* Is a GMT date/time value (can check the Last Sync Time of your storage account).
* All primary writes before the Last Sync Time have been successfully written to the secondary location (available to be read from the secondary location)
* If Microsoft initiates failover to the secondary region, read and write access is available to data after the failover has completed.
* For more information, see Disaster recovery guidance.
* For information on how to switch to the secondary region, see What to do if an Azure Storage outage occurs.
* RA-GRS is intended for high-availability purposes. For scalability guidance, review the performance checklist.
* For suggestions on how to design for high availability with RA-GRS, see Designing Highly Available Applications using RA-GRS storage.

### long-term backup retention (LTR) policy

can store specified SQL database full backups in RA-GRS blob storage for up to 10 years. You can then restore any backup as a new database.
